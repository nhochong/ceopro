<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: create.tpl 8235 2011-01-18 00:28:14Z john $
 * @author     John
 */
?>

<?php if( $this->form ): ?>
    <?php echo $this->form->render($this) ?>

    <script type="text/javascript">

        function updateIconType(el, inputId)
        {
            if (el.value == 'icon_class') {
                $(inputId).show();
            } else {
                $(inputId).hide();
            }
        }

        window.addEvent('domready', function() {
            $('icon').onchange();
            $('hover_active_icon').onchange();
        });
    </script>

<?php elseif( $this->status ): ?>

    <div><?php echo $this->translate("Your changes have been saved.") ?></div>

    <script type="text/javascript">
        setTimeout(function() {
            parent.window.location.replace( '<?php echo $this->url(array('action' => 'index', 'name' => $this->selectedMenu->name)) ?>' )
        }, 500);
    </script>

<?php endif; ?>