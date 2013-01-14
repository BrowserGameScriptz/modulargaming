<?php defined('SYSPATH') OR die('No direct access allowed.');

class Model_User_Item extends ORM {

	protected $_belongs_to = array(
		'item' => array(
			'model' => 'Item',
			'foreign_key' => 'item_id'
		),
		'user' => array(
			'model' => 'User',
			'foreign_key' => 'user_id'
		),
	);

	protected $_load_with = array('item', 'user');

	public function rules()
	{
		return array(
			'amount' => array(
				array('not_empty'),
				array('digit'),
			),
			'location' => array(
				array('not_empty'),
				array('max_length', array(':value', 60)),
			),
		);
	}
	
	/**
	 * Return the item's image url
	 * 
	 * @return string
	 */
	public function img(){
		return $this->item->img();
	}
	
	/**
	 * Move the currently initialised item to a new location and update its quantity.
	 * 
	 * Returns false if you're trying to move a higher amount of this item than you already have,
	 * if successfull it will return the instance of the user item stack where the copies have moved to.
	 * 
	 * @param string $location
	 * @param integer $amount
	 * @return boolean|Model_User_Item
	 */
	public function move($location, $amount=1) {
		return $this->_relocate($this->user_id, $location, $amount);
	}
	
	/**
	 * Transfer the initialised item to a different user.
	 * 
	 * Returns false if you're trying to transfer a higher amount of this item than the owner already has,
	 * if successfull it will return a user item instance of where the item copies transfered to.
	 * 
	 * @param Model_User $user A user model instance of the new owner
	 * @param Integer $amount The amount of copies you want to transfer
	 * @throws Kohana_Exception When trying to transfer an untrasferable item
	 * @return boolean|Model_User_Item
	 */
	public function transfer(Model_User $user, $amount=1) {
		if($this->item->transferable == false)
			Throw new Kohana_Exception('":item" is bound to your account only.', array(':item' => $this->item->name));
		else
			return $this->_relocate($user->id, 'inventory', $amount);
	}
	
	/**
	 * Move the item to
	 * - a new location
	 * - a new user
	 * 
	 * @param integer $user_id The (new) owner of the item
	 * @param string $location The new location of the item
	 * @param integer $amount The amount of copies to relocate
	 * @return boolean|Model_User_Item
	 */
	protected function _relocate($user_id, $location, $amount) {
		if($amount > $this->amount)
			return false;
		
		//check if the item already has a stack for its new location
		$user_item = ORM::factory('User_Item')
		->where('user_id', '=', $user_id)
		->where('item_id', '=', $this->item_id)
		->where('location', '=', $location)
		->find();
		
		if($user_item->loaded()) {
			$user_item->amount = $user_item->amount + $amount;
			$user_item->save();
		}
		else { //doesn't seem like it, let's create a new stack
			$user_item = ORM::factory('User_Item');
			$user_item->user_id = $user_id;
			$user_item->item_id = $this->item_id;
			$user_item->location = $location;
			$user_item->save();
		}
		
		//update the amount
		$new_amount = $this->amount - $amount;
		
		if($new_amount == 0)
			$this->delete();
		else {
			$this->amount = $new_amount;
			$this->save();
		}
		
		return $user_item;
	}

} // End User_Item Model