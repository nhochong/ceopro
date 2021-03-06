<?php return array(
    'package' =>
        array(
            'type' => 'module',
            'name' => 'ynresponsivepurity',
            'version' => '4.02p3',
            'path' => 'application/modules/Ynresponsivepurity',
            'title' => 'YNC - Responsive Purity Template',
            'description' => 'Responsive Purity Template',
            'author' => '<a href="http://socialengine.younetco.com/" title="YouNetCo" target="_blank">YouNetCo</a>',
            'callback' =>
                array(
                    'class' => 'Engine_Package_Installer_Module',
                ),
            'actions' =>
                array(
                    0 => 'install',
                    1 => 'upgrade',
                    2 => 'refresh',
                    3 => 'enable',
                    4 => 'disable',
                ),
            'directories' =>
                array(
                    0 => 'application/modules/Ynresponsivepurity',
                ),
            'files' =>
                array(
                    0 => 'application/languages/en/ynresponsivepurity.csv',
                ),
            'dependencies' =>
                array(
                    0 =>
                        array(
                            'type' => 'module',
                            'name' => 'younet-core',
                            'minVersion' => '4.02p13',
                        ),
                    1 =>
                        array(
                            'type' => 'module',
                            'name' => 'ynresponsive1',
                            'minVersion' => '4.05p2',
                        ),
                ),
        ),
    'items' =>
        array(
            0 => 'ynresponsivepurity_slider',
            1 => 'ynresponsivepurity_welcome',
            2 => 'ynresponsivepurity_module',
        ),
); ?>