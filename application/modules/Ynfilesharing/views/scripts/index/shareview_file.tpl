<?php
$this->headScript ()->appendFile ( $this->baseUrl() . '/application/modules/Ynfilesharing/externals/scripts/scribd_api.js' );

?>

<script type="text/javascript">
  var status = '<?php echo $this->status ?>';
  if (status == 'DONE')
  {
	  var doc_id = '<?php echo $this->data['doc_id']?>';
	  var access_key = '<?php echo $this->data['access_key']?>';
	  var mode = '<?php echo $this->mode ?>';
	  var width = '<?php echo $this->width ?>';
	  var height = '<?php echo $this->height ?>';

	  var scribd_doc = scribd.Document.getDoc(doc_id, access_key);
	  var onDocReady = function(e){
	    // scribd_doc.api.setPage(3);
	  };
	  scribd_doc.addParam('jsapi_version', 2);
	  scribd_doc.addParam('mode', mode);
	  if (width != '' && height != '') {
	  	scribd_doc.addParam('width', width);
	  	scribd_doc.addParam('height', height);
	  }
	  scribd_doc.addEventListener('docReady', onDocReady);
	  scribd_doc.write('embedded_doc');
  }
</script>

<div class="ynfs_filepreview">
	<div class="ynfs_filepreview_filename">
	<?php
		$file_img_url = $this->baseUrl() . "/application/modules/Ynfilesharing/externals/images/file_types/" . $this->file->getFileIcon();
		$file_path = $this->layout()->staticBaseUrl . "filesharing/file/download/" . $this->file->getIdentity();
	?>

		<div class="ynfs_icon ynfs_file_default" style="background-image: url(<?php echo $file_img_url ?>);float: left;">
    	</div>
    	<div><?php echo $this->htmlLink($this->file->getHref(),$this->file->name)?>
    		<?php echo $this->translate('posted by');?> <?php echo $this->htmlLink($this->file->getOwner()->getHref(), $this->file->getOwner()->getTitle()) ?>
    	</div>

		<button onclick="location.href='<?php echo $file_path  ?>';" style="float:right;" name="filepreview_download" id="filepreview_download" type="button">Download</button>
	</div>
</div>
<br>
<?php if($this -> api_viewer):?>
	<div id='embedded_doc'></div>
<?php elseif($this->is_support && !$this->is_image):?>
	<iframe src="https://docs.google.com/viewer?url=<?php echo $this -> file_path?>&embedded=true" class = "ynfs_googleviewer_info" frameborder="0"></iframe> 
<?php endif;?>
<?php
	if (!$this->is_support && !$this->is_image) :
			echo "<div class='tip'><span >" . $this->translate('This document is not supported to be previewed.') . "</span></div>";
 elseif (!$this->is_support) :
	echo "<div class='tip'><span >" . $this->translate('This document is not supported to be previewed') . "</span></div>";
 elseif (!$this->is_success) :
 	echo "<div class='tip'><span >" . $this->translate('Sorry, there is something wrong with uploading document to preview') . "</span></div>";

 elseif ($this->status != 'DONE') : ?>

 <?php endif; ?>
 <br>