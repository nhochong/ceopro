<?php
class Advgroup_Widget_ProfileYnultimatevideoVideosController extends Engine_Content_Widget_Abstract{

    protected $_childCount;

    public function indexAction(){
        // Don't render this if not authorized
        $this->view->viewer = $viewer = Engine_Api::_()->user()->getViewer();
        if( !Engine_Api::_()->core()->hasSubject() ) {
            return $this->setNoRender();
        }

        if(!Engine_Api::_()->hasItemType('ynultimatevideo_video'))
        {
            return $this->setNorender();
        }
        // Get subject and check auth
        $this->view->group = $subject = Engine_Api::_()->core()->getSubject('group');
        if($subject->is_subgroup && !$subject->isParentGroupOwner($viewer)){
            $parent_group = $subject->getParentGroup();
            if(!$parent_group->authorization()->isAllowed($viewer , "view")){
                return $this->setNoRender();
            }
            else if(!$subject->authorization()->isAllowed($viewer , "view")){
                return $this->setNoRender();
            }
        }
        else if( !$subject->authorization()->isAllowed($viewer, 'view') ) {
            return $this->setNoRender();
        }
        //Get number of videos display
        $max = $this->_getParam('itemCountPerPage');
        if(!is_numeric($max) | $max <=0) $max = 5;

        $marginLeft = $this->_getParam('marginLeft', '');
        if (!empty($marginLeft)) {
            $this->view->marginLeft = $marginLeft;
        }

        $params = array();
        $params['parent_type'] = 'group';
        $params['parent_id'] = $subject->getIdentity();
        $params['orderby'] = 'creation_date';
        $params['page'] = $this->_getParam('page',1);
        $params['limit'] = $max;

        //Get data from table Mappings
        $tableMapping = Engine_Api::_()->getItemTable('advgroup_mapping');

        //Get data from table video
        $tableVideo = Engine_Api::_()->getItemTable('ynultimatevideo_video');
        $select = $tableVideo -> select()
            -> from($tableVideo->info('name'), new Zend_Db_Expr("`video_id`"))
            -> where('parent_type = "group"')
            -> where('status = 1')
            //@TODO consider checking for search condition, requires BA confirmation
//            -> where('search = 1')
            -> where('parent_id = ?', $subject -> getIdentity());
        $video_ids = $tableVideo -> fetchAll($select);

        foreach($video_ids as $video_id)
        {
            $params['ids'][] = $video_id -> video_id;
        }
        $this->view->paginator = $paginator = $subject -> getUltimateVideosPaginator($params);

        $canCreate = $subject -> authorization() -> isAllowed($viewer, 'video');
        $levelCreate = Engine_Api::_() -> authorization() -> getAdapter('levels') -> getAllowed('group', $viewer, 'video');

        if ($canCreate && $levelCreate) {
            $this -> view -> canCreate = true;
        } else {
            $this -> view -> canCreate = false;
        }

        // Add count to title if configured
        if( $this->_getParam('titleCount', false) && $paginator->getTotalItemCount() > 0 ) {
            $this->_childCount = $paginator->getTotalItemCount();
        }
    }

    public function getChildCount()
    {
        return $this->_childCount;
    }
}
?>
