<?php $session = new Zend_Session_Namespace('mobile');
if(!$session -> mobile){?>
  <div class="headline">
	  <h2>
	    <?php echo $this->translate("Blogs");?>
	  </h2>
	  <?php if( count($this->navigation) > 0 ): ?>
	    <div class="tabs">          
	          <?php
	            /* Render the menu */
	            echo $this->navigation()
	              ->menu()
	              ->setContainer($this->navigation)
	              ->render();
	          ?>
			  <div class="rss_icon">
	                <a href="<?php echo $this->url(array('action' => 'rss'), 'blog_general') ?>"></a>
	          </div>          
	    </div>
	  <?php endif; ?>
  </div>
  <?php }
  else
  {?>
  	<div id='tabs'>
	  	<ul class="ymb_navigation_more">
		  <?php 
		  $max = 2;
		  $count = 0;
		  foreach( $this->navigation as $item ): $count ++;
		  $attribs = array_diff_key(array_filter($item->toArray()), array_flip(array(
	        'reset_params', 'route', 'module', 'controller', 'action', 'type',
	        'visible', 'label', 'href'
	        )));
		    if($count <= $max):?>
		     <li<?php echo($item->active?' class="active"':'')?>>
          		<?php echo $this->htmlLink($item->getHref(), $this->translate($item->getLabel()), $attribs) ?>
        	</li>	
		  <?php endif; endforeach; ?>
		  <?php if(count($this->navigation) > $max):?>
		  <li class="ymb_show_more_menus">
		  	<a href="javascript:void(0)" class="ymb_showmore_menus">
		  		<i class="icon_showmore_menus">
		  			<?php echo $this-> translate("Show more");?>
		  		</i>	  		  		
		  	</a>
		  	<div class="ymb_listmore_option">
		  		<div class="ymb_bg_showmore">
		  			<i class="ymb_arrow_showmore"></i>
		  		</div>	  		
			<?php 
			 	$count = 0;
				foreach( $this->navigation as $item ): $count ++;
				 $attribs = array_diff_key(array_filter($item->toArray()), array_flip(array(
			        'reset_params', 'route', 'module', 'controller', 'action', 'type',
			        'visible', 'label', 'href'
			        )));
				if($count > $max):
			?>
				<div<?php echo($item->active?' class="active"':'')?>>
				     <?php echo $this->htmlLink($item->getHref(), $this->translate($item->getLabel()), $attribs) ?>
				 </div>
				 <?php endif; endforeach; ?>
			</div>
		  </li>
		  <?php endif;?>
		</ul>
	</div>
	<script type="text/javascript">
		jQuery(function(){
			jQuery('.ymb_show_more_menus').click(function(){
				jQuery(this).find('.ymb_listmore_option').toggle();
			})
		});
	</script>
  <?php  }?>
  