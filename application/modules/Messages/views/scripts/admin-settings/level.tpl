<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Messages
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: level.tpl 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */
?>

<div class='clear'>

  <?php
    echo $this->navigation()
      ->menu()
      ->setContainer($this->navigation)
      ->setUlClass('admin_levels_tabs')
      ->render()
  ?>

  <div class='settings'>
    <?php echo $this->form->render($this) ?>
  </div>

</div>