<?php if ($this->is_ajax): ?>
<?php $strRand = rand(1,100).rand(1,100);?>
<div id="album_listing_recent<?php echo $strRand?>"></div>
<script type="text/javascript">
 function do_onload() {
    var l = document.getElementById('album_listing_recent<?php echo $strRand?>');
    l.innerHTML = '<img src="./application/modules/Advalbum/externals/images/loading.gif"/>';
    var limit = <?php echo $this->limit?>;
     var makeRequest = new Request(
            {
                url: "advalbum/ajax/recent-albums/number/"+ limit,
                onComplete: function (respone){
                 l.innerHTML = respone;
                }
            }
    )
    makeRequest.send();
 }
document.onload = do_onload();
</script>
<?php else: ?>
<?php
$css = "";
if($this->no_title)
{
	$css .= " ".$this->no_title;
}
$no_albums_message = $this->translate('There has been no album in this category yet.');
echo $this->partial('_albumlist.tpl', 'advalbum', array(
	'arr_albums' => $this->arr_albums, 
	'album_listing_id'=> $this->identity,
	'no_albums_message'=>$no_albums_message, 
	'short_title'=>1, 
	'css'=>$css,
	'class_mode' => $this->class_mode,
	'view_mode' => $this->view_mode,
	'mode_enabled' => $this->mode_enabled,
));
?>
<?php endif; ?>

