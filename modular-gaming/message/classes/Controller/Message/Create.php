<?php defined('SYSPATH') OR die('No direct script access.');


class Controller_Message_Create extends Controller_Message {

	public function action_index()
	{
		if ($this->request->method() == HTTP_Request::POST)
		{
			try
			{
				$message_data = Arr::merge($this->request->post(), array(
					'sender_id' => $this->user->id,
				));

				$message = ORM::factory('Message')
					->create_message($message_data, array(
						'receiver_id',
						'subject',
						'content',
						'sender_id',
					));

				Hint::success('You have sent a message');
				$this->redirect('messages');
			}
			catch (ORM_Validation_Exception $e)
			{
				Hint::error($e->errors('models'));
			}

		}

		$this->view = new View_Message_Create;
	}

}