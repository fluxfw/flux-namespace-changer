<?php

namespace FluxNamespaceChanger;

require_once __DIR__ . "/../libs/flux-autoload-api/autoload.php";

use FluxNamespaceChanger\Libs\FluxAutoloadApi\Adapter\Autoload\Psr4Autoload;
use FluxNamespaceChanger\Libs\FluxAutoloadApi\Adapter\Checker\PhpVersionChecker;

PhpVersionChecker::new(
    ">=8.1"
)
    ->checkAndDie(
        __NAMESPACE__
    );

Psr4Autoload::new(
    [
        __NAMESPACE__ => __DIR__
    ]
)
    ->autoload();
