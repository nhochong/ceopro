<?php
	$staticBaseUrl = $this->layout()->staticBaseUrl; 
    $this->headLink() ->prependStylesheet($staticBaseUrl . 'application/modules/Ynmultilisting/externals/styles/bootstrap.min.css');
    $this->headScript()->appendFile($staticBaseUrl . 'application/modules/Ynmultilisting/externals/scripts/xls/xls.js');
    $this->headScript()->appendFile($staticBaseUrl . 'application/modules/Ynmultilisting/externals/scripts/jquery.min.js');
    $this->headScript()->appendFile($staticBaseUrl . 'application/modules/Ynmultilisting/externals/scripts/jquery.csv-0.71.js');
?>
<script type="text/javascript">
var cancel = false;
var rollback = false;
var import_status = true;
var message = '';
var unlimit = <?php echo ($this->max_import == 0) ? '1' : '0'?>;
var max_import = <?php echo $this->max_import?>;
var auth = {};
var url = '<?php echo $this->url(array('module'=>'ynmultilisting','action'=>'file-one-by-one','controller'=>'import'),'admin_default')?>';
var listings = new Array();
var import_count = 0;
var listings_imported = new Array();
var total = 0;
jQuery.noConflict();
        
function cancel_import(event) {
    event.preventDefault();
    Smoothbox.open($('cancelImport'));
}

function cancel_ok() {
    if (listings.length > 0)
        cancel = true;
    parent.Smoothbox.close();
}
    
function rollback_import(event) {
    event.preventDefault();
    Smoothbox.open($('rollbackImport'));
}

function rollback_ok() {
    if (listings.length > 0)
        rollback = true;
    parent.Smoothbox.close();
}

function import_process() {
    if (import_status && !cancel && !rollback && (max_import > 0 || unlimit == 1) && listings.length > 0) {
        new Request.JSON({
            url: url,
            method: 'post',
            data: {
                'listing': JSON.encode(listings[0]),
                'auth': JSON.encode(auth),
                'approved': $$('input[type=radio][name=approved]:checked')[0].get('value'),
                'package_id': $('package_id').get('value')
            },
            onSuccess: function(json) {
                import_status = json.status;
                if (json.id != null) {
                    listings_imported.push(json.id);
                }
                message = json.message;
                
                if (json.status) {
                    listings.splice(0, 1);
                }
                
                if (json.status && json.id != null) {
                    max_import--;
                    import_count++;
                }
                
                var progress = parseInt(import_count / total * 100, 10);
                $$('#progress .progress-bar').setStyle(
                    'width',
                    progress + '%'
                );
                $$('#progress-percent').setStyle('display', 'inline-block').set('text',
                    progress + '%'
                );
            
                import_process();
            }
        }).send();
    }
    else {
        if (!import_status) {
            Smoothbox.close();
            $$('#importFail p')[0].set('text', message);
            Smoothbox.open($('importFail'));
        }
        else if (cancel) {
            Smoothbox.close();
            $$('#importCancel p')[0].set('text', import_count+' <?php echo $this->translate('listing(s) have been imported.')?>');
            Smoothbox.open($('importCancel'));
        }
        else if (rollback) {
            new Request.JSON({
                url: '<?php echo $this->url(array('action' => 'file-rollback'), 'ynmultilisting_import', true)?>',
                method: 'post',
                data: {
                    'listings': JSON.encode(listings_imported)
                },
            }).send();
            Smoothbox.close();
            Smoothbox.open($('importRollback'));
        }
        else if (max_import <= 0 && unlimit == 0) {
            Smoothbox.close();
            $$('#importLimit p')[0].set('text', import_count+' <?php echo $this->translate('listing(s) have been imported.')?>');
            Smoothbox.open($('importLimit'));
        }
        else if (listings.length == 0) {
            Smoothbox.close();
            $$('#importSuccess p')[0].set('text', '<?php echo $this->translate('Total')?> '+import_count+' <?php echo $this->translate('listing(s) have been imported.')?>');
            Smoothbox.open($('importSuccess'));
        }
        
        if (import_count > 0 && !rollback) {
            var filename = $('file').get('value').split("\\").pop();
            new Request.JSON({
                url: '<?php echo $this->url(array('module'=>'ynmultilisting','action'=>'file-history','controller'=>'import'),'admin_default')?>',
                method: 'post',
                data: {
                    'listings': JSON.encode(listings_imported),
                    'filename': filename,
                    'approved': $$('input[type=radio][name=approved]:checked')[0].get('value')
                },
            }).send();
        }
        cancel = false;
        rollback = false;
        import_status = true;
        message = '';
        max_import = <?php echo $this->max_import?>;
        auth = {};
        listings = new Array();
        listings_imported = new Array();
        import_count = 0;
        total = 0;
        $$('#progress .progress-bar').setStyle(
            'width',
            0 + '%'
        );
        $$('#progress-percent').setStyle('display', 'inline-block').set('text',
            0 + '%'
        );
        $("submit_btn").show();
        $("btn_import").hide();
        $("progress").hide();
    }
}

function excute_import(error) {
    var file = $('file'); 
    var ext = file.get('value').split(".").pop().toLowerCase();
    if (file.files != undefined) {
        var reader = new FileReader();
        reader.onload = function(e) {
            if (ext == 'xls') {
                var ori_data = e.target.result;
                var data = ori_data.trim();
                var wb = XLS.read(data, {type: 'binary'});
                var str = XLS.utils.sheet_to_csv(wb.Sheets[wb.SheetNames[0]]);
				if (ori_data != data) {
					str = decodeURIComponent(escape(str));
				}
            }
            
            else {
                str = e.target.result; 
                str = str.trim();           // load file values
            }
            var lines = jQuery.csv.toArrays(str);
            
            for(var i=0;i<lines.length;i++) {
                if(lines[i] && lines[i][0] != "#") {
                    listings.push(lines[i]);
                }
            } 
            
            var auth_arr = ['auth_view', 'auth_comment', 'auth_share', 'auth_photo', 'auth_discussion'];
            <?php if ($this->videoEnable) : ?>
                auth_arr.push('auth_video');
            <?php endif; ?>
            for (var i = 0; i < auth_arr.length; i++) {
                auth[auth_arr[i]] = $(auth_arr[i]).get('value');
            }
            total = listings.length;
            $("submit_btn").hide();
            $("btn_import").show();
            $(progress).show();
            import_process();
        }
        if (ext == 'xls' && error) reader.readAsBinaryString(file.files[0]);
        else reader.readAsText(file.files[0]);
    };
}

function import_listings(event) {
    event.preventDefault();
    var file = $('file'); 
    var ext = file.get('value').split(".").pop().toLowerCase();
    if(!['csv', 'xls'].contains(ext)) {
        alert('Import file is invalid.');
        return false;
    }
    
    if (ext == 'xls' && file.files != undefined) {
        var fReader = new FileReader();
        fReader.onload = function(e) {
            var data = e.target.result;
            try {
                var wb = XLS.read(data, {type: 'binary'});
                var str = XLS.utils.sheet_to_csv(wb.Sheets[wb.SheetNames[0]]);
                excute_import(false);
            }
            catch (err) {
                error = true;
                excute_import(true);
                fReader.abort();
            }
        }
        fReader.readAsText(file.files[0]);
    }
    else if (ext == 'csv' && file.files != undefined) {
        excute_import(false);
    }
}
    
</script>
<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>
<h3><?php echo $this->translate('Import Listings') ?></h3>
<a href="<?php echo $this->url(array('module'=>'ynmultilisting','controller'=>'import','action'=>'view-history'),'admin_default')?>"><i class="fa fa-history"></i> <?php echo $this->translate('View Import History')?></a>
<p><?php echo $this->translate("YNMULTILISTING_ADMIN_IMPORT_DESCRIPTION") ?></p>      
<br/>

<div id="ynmultilisting-import-tab">
    <div id="ynmultilisting-file-tab" class="active">
        <?php echo $this->htmlLink(array('route' => 'admin_default', 'module'=>'ynmultilisting', 'controller'=>'import', 'action' => 'file'), $this->translate('Import Listings From Files'))?>
    </div>
    <div id="ynmultilisting-module-tab">
        <?php echo $this->htmlLink(array('route' => 'admin_default', 'module'=>'ynmultilisting', 'controller'=>'import', 'action' => 'module'), $this->translate('Import Listings From Modules'))?>
    </div>
</div>

<?php if ($this->error):?>
<div class="tip">
	<span><?php echo $this->message?></span>
</div>
<?php else: ?>
<div class='clear'>
    <div class='settings'>
    <?php echo $this->form->render($this); ?>
    </div>
</div>
<div id="btn_import" style="display:none">
    <button onclick="cancel_import(event)"><?php echo $this->translate('Cancel')?></button>
    <button onclick="rollback_import(event)"><?php echo $this->translate('Rollback')?></button>
    <div class="progress-contain">
        <div id="progress" class="progress" style="display: none; margin-top: 10px; width: 400px; float:left">
            <div class="progress-bar progress-bar-success"></div>
        </div>
        <span id="progress-percent" style="margin-top: 10px;"></span>
    </div>
</div>

<div id="pop_up">
    <div id="cancelImport">
        <h3><?php echo $this->translate('Cancel Import Listings')?></h3>
        <p><?php echo $this->translate('Are you sure you want to cancel this process? Some of listings can not be imported successfully.')?></p>
        <button onclick="cancel_ok()"><?php echo $this->translate("Ok") ?></button>
        <?php echo $this->translate(" or ") ?> 
        <a class="import_link" href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
        <?php echo $this->translate("cancel") ?></a>
    </div>
    <div id="rollbackImport">
        <h3><?php echo $this->translate('Rollback Import Listings')?></h3>
        <p><?php echo $this->translate('Are you sure you want to rollback this process?')?></p>
        <button onclick="rollback_ok()"><?php echo $this->translate("Ok") ?></button>
        <?php echo $this->translate(" or ") ?> 
        <a class="import_link" href='javascript:void(0);' onclick='javascript:parent.Smoothbox.close()'>
        <?php echo $this->translate("cancel") ?></a>
    </div>
    <div id="importFail">
        <h3><?php echo $this->translate('Import Fail')?></h3>
        <p></p>
        <button onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Ok") ?></button>
    </div>
    <div id="importCancel">
        <h3><?php echo $this->translate('Import has been canceled')?></h3>
        <p></p>
        <button onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Ok") ?></button>
    </div>
    <div id="importRollback">
        <h3><?php echo $this->translate('Import has been rollbacked')?></h3>
        <p><?php echo $this->translate('Import listings process has been rollbacked.')?></p>
        <button onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Ok") ?></button>
    </div>
    <div id="importLimit">
        <h3><?php echo $this->translate('Import reaches limit')?></h3>
        <p></p>
        <button onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Ok") ?></button>
    </div>
    <div id="importSuccess">
        <h3><?php echo $this->translate('Import successful')?></h3>
        <p></p>
        <button onclick="javascript:parent.Smoothbox.close()"><?php echo $this->translate("Ok") ?></button>
    </div>
</div>

<?php endif; ?>