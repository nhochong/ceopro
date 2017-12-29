<?php

class Ynresponsive1_Form_Admin_Container2 extends Engine_Form
{
  function init()
  {
    $this -> addElement('select', 'container_split', array(
      'label' => 'Container Split',
      'multiOptions' => array(
        '1.1' => '1/2 -  1/2',
        '2.1' => '2/3 -  1/3',
        '3.1' => '3/4 -  1/4',
        '1.2' => '1/3 -  2/3',
        '1.3' => '1/4 -  3/4',
      ),
    ));
  }

}
