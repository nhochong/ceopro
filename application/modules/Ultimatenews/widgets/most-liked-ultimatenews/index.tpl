<ul>
    <?php
    foreach ($this->likedultimatenews as $item):
    ?>      	
        <li class="layout_ultimatenews_popular_new">          
            <div class='widget_innerholder_ultimatenews'>
                <?php if($item->logo_icon != "" && $item->logo_icon):?>
                    <p><img src="<?php echo $item->logo_icon?>" /></p>
                <?php else: ?>
                    <span class="ynicon yn-rss-circle"></span>
                <?php endif;?>
                <h4 class="ynnew-tt3"><?php echo $this->htmlLink($item->getHref(), $item->title, array('target' => '_parent'))?></h4>
                <p class="ynultimatenews-info3">
                    <?php echo $this->translate('Posted') . " " . $item->pubDate_parse;// . " " . $this->translate('by') . ": " . Engine_Api::_()->getItem('user',$item->owner_id);?>
                </p>
                <p class="ynultimatenews-bd3">

                    <?php
                    if ($item->image != ""):
						$img_path = $item->image;
						if($item->photo_id)
						{
							$img_path = $item->getPhotoUrl();
						}
						echo("<img src='" . $img_path . "' align='left' />");
                    else: 
						echo '<img class="ynultimatenews-smallthumb" align="left" src="./application/modules/Ultimatenews/externals/images/small_news.png" alt=""/> ';
                    endif;
                    $content = $item->description ? $item->description : $item->content;
                    echo $this->feedDescription($content);
                    ?>
                </p>	             
                <div style="clear:both;"></div>
                <p class="ynultimatenews-ft3">
                    <?php echo $this->translate('Likes') . ": " . "<font style='font-weight:bold'>" . $item->count_like . "</font>";?>
                    <a class="ynultimatenews-viewmore" href="<?php echo($item->getHref());?>" target="_blank" ><?php echo $this->translate('View more') . '...';?></a>
                </p>
            </div>
        </li>
    <?php endforeach;?>
</ul>
