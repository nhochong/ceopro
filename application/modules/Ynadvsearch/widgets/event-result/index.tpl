<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: browse.tpl 9987 2013-03-20 00:58:10Z john $
 * @author     John Boehr <john@socialengine.com>
 */
?>
<div class='count_results'>
	<span class="search_icon fa fa-search"></span>
	<span class="num_results"><?php echo $this->translate(array('%s Result', '%s Results', $this->paginator->getTotalItemCount()),$this->paginator->getTotalItemCount())?></span>
	<span class="total_results">(<?php echo $this->total_content?>)</span>
	<span class="label_results"><?php echo $this->htmlLink(array('route' => 'event_general'), $this->label_content, array());?></span>
</div>

<?php if( count($this->paginator) > 0 ): ?>
	<ul class='events_browse'>
		<?php foreach( $this->paginator as $event ): ?>
			<li>
				<div class="events_photo">
					<?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.normal')) ?>
				</div>
				<div class="events_options">
				</div>
				<div class="events_info">
					<div class="events_title">
						<h3><?php echo $this->htmlLink($event->getHref(), $event->getTitle()) ?></h3>
					</div>
					<div class="events_members">
						<?php echo $this->locale()->toDateTime($event->starttime) ?>
					</div>
					<div class="events_members">
						<?php echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>
						<?php echo $this->translate('led by') ?>
						<?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?>
					</div>
					<div class="events_desc">
						<?php echo $event->getDescription() ?>
					</div>
				</div>
			</li>
		<?php endforeach; ?>
	</ul>

	<?php if( $this->paginator->count() > 1 ): ?>
		<?php echo $this->paginationControl($this->paginator, null, null, array(
			'query' => $this->formValues,
			)); ?>
	<?php endif; ?>

<?php elseif( preg_match("/category_id=/", $_SERVER['REQUEST_URI'] )): ?>
	<div class="tip">
		<span>
			<?php echo $this->translate('There were no events found matching your search criteria.');?>
		</span>
	</div>   

<?php else: ?>
	<div class="tip">
		<span>
			<?php if( $this->filter != "past" ): ?>
				<?php echo $this->translate('There were no events found matching your search criteria.') ?>
			<?php else: ?>
				<?php echo $this->translate('There were no events found matching your search criteria.') ?>
			<?php endif; ?>
		</span>
	</div>

<?php endif; ?>

<script type="text/javascript">
	$$('.core_main_event').getParent().addClass('active');
</script>
