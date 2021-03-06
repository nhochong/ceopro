<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Ynforum
 * @author     MinhNC
 */
class Ynforum_EventController extends Core_Controller_Action_Standard {

	public function init() {
		if (!Engine_Api::_() -> hasItemType('event')) {
			return $this -> _helper -> requireAuth() -> forward();
		}
		if (0 !== ($forum_id = (int)$this -> _getParam('forum_id')) && null !== ($forum = Engine_Api::_() -> getItem('ynforum_forum', $forum_id))) {
			if (!Engine_Api::_() -> core() -> hasSubject($forum -> getType())) {
				Engine_Api::_() -> core() -> setSubject($forum);
			}
			$this -> view -> forum = $forum;
			$this -> view -> navigationForums = $forum -> getForumNavigations();
			$list = $forum -> getModeratorList();
			$moderators = $list -> getAllChildren();
			$arr_temp = array();
			foreach ($moderators as $moderator) {
				if ($moderator -> getIdentity())
					$arr_temp[] = $moderator;
			}
			$this -> view -> moderators = $arr_temp;

			$categoryTable = Engine_Api::_() -> getItemTable('ynforum_category');
			$cats = $categoryTable -> fetchAll($categoryTable -> select() -> order('order ASC'));
			$categories = array();
			foreach ($cats as $cat) {
				$categories[$cat -> getIdentity()] = $cat;
			}
			$curCat = $categories[$forum -> category_id];
			$linkedCategories = array();
			do {
				$linkedCategories[] = $curCat;
				if (!$curCat -> parent_category_id) {
					break;
				}
				$curCat = $categories[$curCat -> parent_category_id];
			} while (true);
			$this -> view -> linkedCategories = $linkedCategories;
		}
	}

	public function manageAction() {
		if (!$this -> _helper -> requireSubject('forum') -> isValid()) {
			return;
		}
		$forum = Engine_Api::_() -> core() -> getSubject();
		if (!$this -> _helper -> requireAuth -> setAuthParams($forum, null, 'view') -> isValid()) {
			return;
		}
		$this -> view -> viewer = $viewer = Engine_Api::_() -> user() -> getViewer();
		if (!$forum -> checkPermission($viewer, 'forum', 'fevent.edit')) {
			return $this -> _helper -> requireAuth() -> forward();
		}

		// get events
		$page = $this -> _getParam('page', 1);
		$eventTable = Engine_Api::_() -> getItemTable('event');
		$eventTableName = $eventTable -> info('name');
		$filter = $this -> _getParam('filter');
		$select = $eventTable -> select() -> where('user_id = ?', $viewer -> getIdentity());
		$select -> where('parent_type = ?', 'forum');
		$select -> where('parent_id = ?', $forum -> getIdentity());
		switch ($filter) {
			case 'ongoing' :
				$select -> where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?) AND `{$eventTableName}`.`starttime` <= FROM_UNIXTIME(?)", time());
				break;
			case 'past' :
				$select -> where("`{$eventTableName}`.`endtime` <= FROM_UNIXTIME(?)", time());
				break;
			default :
				$select -> where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?)", time());
				break;
		}
		$select -> order("starttime ASC");
		$form = new Engine_Form();
		$form -> setAttrib('id', 'ynforum_events_filter');
		$form -> addElement('Select', 'filter', array('label' => 'Filter', 'onchange' => '$(this).getParent("form").submit();', 'multiOptions' => array('upcoming' => 'Upcoming', 'ongoing' => 'Ongoing', 'past' => 'Past'), ));
		$form -> getElement('filter') -> setValue($filter);
		$this -> view -> form = $form;
		$this -> view -> paginator = $paginator = Zend_Paginator::factory($select);
		$this -> view -> paginator -> setItemCountPerPage(10);
		$this -> view -> paginator -> setCurrentPageNumber($page);
	}

	public function indexAction() {
		if (!$this -> _helper -> requireSubject('forum') -> isValid()) {
			return;
		}
		$forum = Engine_Api::_() -> core() -> getSubject();
		if (!$this -> _helper -> requireAuth -> setAuthParams($forum, null, 'view') -> isValid()) {
			return;
		}
		$this -> view -> viewer = $viewer = Engine_Api::_() -> user() -> getViewer();
		// get events
		$page = $this -> _getParam('page', 1);
		$eventTable = Engine_Api::_() -> getItemTable('event');
		$eventTableName = $eventTable -> info('name');
		$filter = $this -> _getParam('filter');
		$select = $eventTable -> select() -> where('search = ?', 1);
		$select -> where('parent_type = ?', 'forum');
		$select -> where('parent_id = ?', $forum -> getIdentity());
		switch ($filter) {
			case 'ongoing' :
				$select -> where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?) AND `{$eventTableName}`.`starttime` <= FROM_UNIXTIME(?)", time());
				break;
			case 'past' :
				$select -> where("`{$eventTableName}`.`endtime` <= FROM_UNIXTIME(?)", time());
				break;
			default :
				$select -> where("`{$eventTableName}`.`endtime` > FROM_UNIXTIME(?)", time());
				break;
		}
		$select -> order("starttime ASC");
		$form = new Engine_Form();
		$form -> setAttrib('id', 'ynforum_events_filter');
		$form -> addElement('Select', 'filter', array('label' => 'Filter', 'onchange' => '$(this).getParent("form").submit();', 'multiOptions' => array('upcoming' => 'Upcoming', 'ongoing' => 'Ongoing', 'past' => 'Past'), ));
		$form -> getElement('filter') -> setValue($filter);
		$this -> view -> form = $form;
		$this -> view -> paginator = $paginator = Zend_Paginator::factory($select);
		$this -> view -> paginator -> setItemCountPerPage(10);
		$this -> view -> paginator -> setCurrentPageNumber($page);
	}

	public function highlightAction() {
		if (!$this -> _helper -> requireUser() -> isValid()) {
			return;
		}
		if (!$this -> _helper -> requireSubject('forum') -> isValid()) {
			return;
		}
		$forum = Engine_Api::_() -> core() -> getSubject();
		$viewer = Engine_Api::_() -> user() -> getViewer();
		if (!$this -> _helper -> requireAuth -> setAuthParams($forum, null, 'view') -> isValid()) {
			return;
		}
		if (!$this -> getRequest() -> isPost())
			return;
		$id = $this -> getRequest() -> getPost('event_id', null);
		$event = Engine_Api::_() -> getItem('event', $id);
		if (!$event || (!$event -> isOwner($viewer) && !$forum -> checkPermission($viewer, 'forum', 'fevent.highlight'))) {
			return $this -> _helper -> requireAuth() -> forward();
		}
		$table = Engine_Api::_() -> getDbTable('highlights', 'ynforum');
		$db = $table -> getAdapter();
		$db -> beginTransaction();
		try {
			$select = $table -> select() -> where("forum_id = ?", $forum -> getIdentity()) -> where('item_id = ?', $id) -> where("type = 'event'") -> limit(1);
			$row = $table -> fetchRow($select);
			if ($row) {
				$row -> highlight = !$row -> highlight;
				$this -> view -> enabled = $row -> highlight;
				$row -> save();
			} else {
				$row = $table -> createRow();
				$row -> setFromArray(array('forum_id' => $forum -> getIdentity(), 'item_id' => $id, 'user_id' => $viewer -> getIdentity(), 'highlight' => 1, 'type' => 'event'));
				$row -> save();
				$this -> view -> enabled = 1;
			}
			$db -> commit();
			$this -> view -> success = true;
		} catch (Exception $e) {
			$db -> rollback();
			$this -> view -> success = false;
		}
	}

	public function createAction() {
		if (!$this -> _helper -> requireUser -> isValid())
			return;
		if (!$this -> _helper -> requireSubject('forum') -> isValid()) {
			return;
		}
		$forum = Engine_Api::_() -> core() -> getSubject();
		if (!$this -> _helper -> requireAuth -> setAuthParams($forum, null, 'view') -> isValid()) {
			return;
		}
		$viewer = Engine_Api::_() -> user() -> getViewer();
		$parent_id = $this -> _getParam('parent_id', $this -> _getParam('forum_id'));

		if (!$forum -> checkPermission($viewer, 'forum', 'fevent.create')) {
			return $this -> _helper -> requireAuth() -> forward();
		}
		$_SESSION['ynforum']['parent_id'] = $parent_id;
		
		// Redirect
		return $this -> _helper -> redirector -> gotoRoute(array('action' => 'create', 'parent_type' => 'forum', 'subject_id' => $parent_id), 'event_general', true);
	}

	public function inviteAction() 
	{
		if (!$this -> _helper -> requireUser -> isValid())
			return;
		if (!$this -> _helper -> requireSubject('forum') -> isValid()) {
			return;
		}
		$forum = Engine_Api::_() -> core() -> getSubject();
		
		// Prepare data
		$this -> view -> viewer = $viewer = Engine_Api::_() -> user() -> getViewer();
		if (!$forum -> checkPermission($viewer, 'forum', 'fevent.create')) {
			return $this -> _helper -> requireAuth() -> forward();
		}
		$event = Engine_Api::_()->getItem('event', $this->_getParam('event_id', null));
		if(!$event)
		{
			return $this->_helper->requireAuth()->forward();
		}
		$this -> view -> event = $event;

		// Prepare guests
		$list = $forum -> getModeratorList();
		$moderators = $list -> getAllChildren();
		$users = array();
		$postsTable = Engine_Api::_() -> getDbtable('posts', 'ynforum');
		$usersIds = $postsTable -> select() -> from($postsTable, 'user_id') -> distinct() -> where('forum_id = ?', $forum -> getIdentity()) -> limit(100) -> query() -> fetchAll(Zend_Db::FETCH_COLUMN);
		if (!empty($usersIds)) {
			$users = Engine_Api::_() -> getItemTable('user') -> find($usersIds);
		} else {
			$users = array();
		}
		$guests = array();
		foreach ($users as $user) 
		{
			if( $event->membership()->isMember($user, null) ) 
			{
		        continue;
		    }
			$guests[] = $user;
		}
		foreach ($moderators as $moderator) 
		{
			if ($moderator -> getIdentity() && !in_array($moderator -> getIdentity(), $usersIds))
			{
				if( $event->membership()->isMember($moderator, null) ) 
				{
			        continue;
			    }
				$guests[] = $moderator;
			}
		}
		// Prepare form
		$this -> view -> form = $form = new Ynforum_Form_Invite_Invite(array('users' => $guests));
		$this -> view -> count = count($guests);

		// Not posting
		if (!$this -> getRequest() -> isPost()) {
			return;
		}

		if (!$form -> isValid($this -> getRequest() -> getPost())) {
			return;
		}
		if(isset($_POST['cancel']))
		{
			return $this -> _helper -> redirector -> gotoRoute(array('action' => 'manage', 'forum_id' => $forum -> getIdentity()), 'ynforum_event', true);
		}
		// Process
		$table = $event -> getTable();
		$db = $table -> getAdapter();
		$db -> beginTransaction();

		try {
			$usersIds = $_POST['users'];
			if(!$usersIds)
			{
				$form -> dummy_users -> addError($this -> view -> translate("Value is required and can't be empty!"));
				return;
			}
			$notifyApi = Engine_Api::_() -> getDbtable('notifications', 'activity');
			foreach ($guests as $user) 
			{
				if (!in_array($user -> getIdentity(), $usersIds)) 
				{
					continue;
				}
				$event -> membership() -> addMember($user) -> setResourceApproved($user);
				if(Engine_Api::_() -> hasModuleBootstrap('event'))
				{
					$notifyApi -> addNotification($user, $viewer, $event, 'event_invite');
				}
				else {
					$notifyApi -> addNotification($user, $viewer, $event, 'ynevent_invite');
				}
			}
			$db -> commit();
		} catch( Exception $e ) 
		{
			$db -> rollBack();
			throw $e;
		}
		return $this -> _helper -> redirector -> gotoRoute(array('action' => 'manage', 'forum_id' => $forum -> getIdentity()), 'ynforum_event', true);
	}

}
