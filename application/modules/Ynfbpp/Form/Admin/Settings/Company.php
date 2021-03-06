<?php

class Ynfbpp_Form_Admin_Settings_Company extends Engine_Form
{
    public function init()
    {
        $this -> setTitle('Company Settings for Profile Popup') -> setDescription('These settings affect all members in your community.');

        $settings = Engine_Api::_() -> getApi('settings', 'core');

        $this -> addElement('Radio', 'ynfbpp_company_enabled', array(
            'label' => "Show profile popup when hover over a company's link",
            'description' => "Show profile popup when hover over a company's link on any page",
            'multiOptions' => array(
                '1' => 'Yes',
                '0' => 'No'
            ),
            'value' => $settings -> getSetting('ynfbpp.company.enabled', 1),
        ));

        $this -> addElement('Radio', 'ynfbpp_company_description', array(
            'label' => 'Show Description',
            'description' => 'Show description of company in 2 lines',
            'multiOptions' => array(
                '1' => 'Yes',
                '0' => 'No'
            ),
            'value' => $settings -> getSetting('ynfbpp.company.description', 1),
        ));

        $this -> addElement('Radio', 'ynfbpp_company_location', array(
            'label' => 'Show Location',
            'description' => 'Show location of company on popup',
            'multiOptions' => array(
                '1' => 'Yes',
                '0' => 'No'
            ),
            'value' => $settings -> getSetting('ynfbpp.company.location', 1),
        ));

        $this -> addElement('Radio', 'ynfbpp_company_website', array(
            'label' => 'Show Website',
            'description' => 'Show website of company on popup',
            'multiOptions' => array(
                '1' => 'Yes',
                '0' => 'No'
            ),
            'value' => $settings -> getSetting('ynfbpp.company.website', 1),
        ));

        $this -> addElement('Radio', 'ynfbpp_company_jobs', array(
            'label' => 'Show Number Of Valid Jobs',
            'description' => 'Show number of valid jobs of company on popup',
            'multiOptions' => array(
                '1' => 'Yes',
                '0' => 'No'
            ),
            'value' => $settings -> getSetting('ynfbpp.company.jobs', 1),
        ));


        // Add submit button
        $this -> addElement('Button', 'submit', array(
            'label' => 'Save Changes',
            'type' => 'submit',
            'ignore' => true
        ));
    }

}
