#!/usr/bin/env php
<?php

require_once __DIR__ . "/../autoload.php";

use FluxNamespaceChanger\NamespaceChanger;

NamespaceChanger::new()
    ->run();
