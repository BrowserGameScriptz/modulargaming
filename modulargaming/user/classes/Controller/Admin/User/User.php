<?php defined('SYSPATH') OR die('No direct script access.');

	class Controller_Admin_User_User extends Controller_Admin_User {

		public function action_index()
		{

			if (!$this->user->can('Admin_User_User_Index'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user index');
			}

			$users = ORM::factory('User')
				->find_all();

			$roles = ORM::factory('Role')
				->find_all();

			$this->view = new View_Admin_User_User_Index;
			$this->_load_assets(Kohana::$config->load('assets.data_tables'));
			$this->_load_assets(Kohana::$config->load('assets.admin_user.user'));
			$this->_nav('user', 'user');
			$this->view->users = $users->as_array();
			$this->view->roles = $roles->as_array();
		}

		public function action_paginate() {

			if (!$this->user->can('Admin_User_User_Paginate'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user paginate');
			}

			if (DataTables::is_request())
			{
				$orm = ORM::factory('User');

				$paginate = Paginate::factory($orm)
					->columns(array('id', 'name'));

				$datatables = DataTables::factory($paginate)->execute();

				foreach ($datatables->result() as $user)
				{
					$datatables->add_row(array (
							$user->name,
							$user->id
						)
					);
				}

				$datatables->render($this->response);
			}
			else
				throw new HTTP_Exception_500();
		}

		public function action_retrieve()
		{

			if (!$this->user->can('Admin_User_User_Retrieve'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user retrieve');
			}

			$this->view = NULL;

			$item_id = $this->request->query('id');

			if ($item_id == NULL)
			{
				$user = ORM::factory('User')
					->where('user.name', '=', $this->request->query('name'))
					->find();
			}
			else
			{
				$user = ORM::factory('User', $item_id);
			}

			$list = array(
				'name'        => $user->name,
				'id'          => $user->id,
			);
			$this->response->headers('Content-Type', 'application/json');
			$this->response->body(json_encode($list));
		}

		public function action_save()
		{

			if (!$this->user->can('Admin_User_User_Save'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user save');
			}

			$values = $this->request->post();
			$this->view = NULL;

			if ($values['id'] == 0)
			{
				$values['id'] = NULL;
			}

			$this->response->headers('Content-Type', 'application/json');

			try
			{
				$user = ORM::factory('User', $values['id']);
				$user->values($values, array('name', 'description', 'dir'));
				$user->save();

				$data = array(
					'action' => 'saved',
					'row'    => array(
						$user->id,
						$user->name
					)
				);
				$this->response->body(json_encode($data));
			} catch (ORM_Validation_Exception $e)
			{
				$errors = array();

				$list = $e->errors('models');

				foreach ($list as $field => $er)
				{
					if (!is_array($er))
					{
						$er = array($er);
					}

					$errors[] = array('field' => $field, 'msg' => $er);
				}

				$this->response->body(json_encode(array('action' => 'error', 'errors' => $errors)));
			}
		}

		public function action_delete()
		{

			if (!$this->user->can('Admin_User_User_Delete'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user delete');
			}

			$this->view = NULL;
			$values = $this->request->post();

			$user = ORM::factory('User', $values['id']);
			$user->delete();

			$this->response->headers('Content-Type', 'application/json');
			$this->response->body(json_encode(array('action' => 'deleted')));
		}

		public function action_role_load()
		{

			if (!$this->user->can('Admin_User_User_Role_Load'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user colour load');
			}

			$user = ORM::factory('User', $this->request->query('id'));

			$roles = $user->roles->find_all();
			$list = array();

			foreach ($roles as $role)
			{
				$list[] = $role->id;
			}

			$this->response->headers('Content-Type', 'application/json');
			$this->response->body(json_encode(array('colours' => $list)));
		}

		public function action_role_delete()
		{

			if (!$this->user->can('Admin_User_User_Role_Delete'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user colour delete');
			}

			$user = ORM::factory('User', $this->request->query('specie_id'));
			$role = ORM::factory('Pet_Colour', $this->request->query('colour_id'));

			if ($user->has('colours', $role))
			{
				$user->remove('colours', $role);
			}

			$this->response->headers('Content-Type', 'application/json');
			$this->response->body(json_encode(array('action' => 'deleted')));
		}

		public function action_role_update()
		{

			if (!$this->user->can('Admin_User_User_Role_Update'))
			{
				throw HTTP_Exception::factory('403', 'Permission denied to view admin users user colour update');
			}

			$user = ORM::factory('User', $this->request->post('user_id'));

			$role = $this->request->post('role_id');
			$r = ORM::factory('Role', $role);

			//save role
			$user->add('roles', $r);

			$this->response->headers('Content-Type', 'application/json');
			$this->response->body(json_encode($file));
		}
	}
