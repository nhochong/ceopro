<?php
class Ynbusinesspages_Widget_BusinessNewestGroupbuysController extends Engine_Content_Widget_Abstract {
	public function indexAction() {
        // Don't render if classified item not available
        if( !Engine_Api::_()->hasModuleBootstrap('groupbuy') ) {
            return $this->setNoRender();
        }
    
        // Don't render this if not authorized
        if( !Engine_Api::_()->core()->hasSubject() ) {
            return $this->setNoRender();
        }
        
        // Get subject and check auth
        $this->view->business = $business = Engine_Api::_()->core()->getSubject('ynbusinesspages_business');
        if(!$business->isViewable() || !$business -> getPackage() -> checkAvailableModule('groupbuy_deal')) {
            return $this->setNoRender();
        }

        //Get search condition
        $params = array();
        $params['business_id'] = $business -> getIdentity();
        $params['ItemTable'] = 'groupbuy_deal';
        $params['order'] = 'recent';
        $limit = $this -> _getParam('itemCountPerPage', 1);
        if (!$limit) {
            $limit = 1;
        }
        $params['limit'] = $limit;
        //Get paginator
        $this -> view -> paginator = $paginator = Engine_Api::_() -> getDbTable('mappings', 'ynbusinesspages') -> getGroupbuysPaginator($params);
        if ($paginator->getTotalItemCount() <= 0) {
            $this->setNoRender();
        } 
    }
}