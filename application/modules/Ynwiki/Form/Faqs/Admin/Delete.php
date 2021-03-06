<?php

class Ynwiki_Form_Faqs_Admin_Delete extends Engine_Form {

	public function init() {
		
	$this -> setTitle('Delete FAQs')
    ->setDescription('Are you sure that you want to delete this FAQs?')
	->setAttribs(array('class'=>''));

	/**
	 * add button groups
	 */
	$this->addElement('Button', 'submit', array(
      'label' => 'Submit',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
      ),
    ));

	}

}
