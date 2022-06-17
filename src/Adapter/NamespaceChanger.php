<?php

namespace FluxNamespaceChanger\Adapter;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;

class NamespaceChanger
{

    private const NEW_LINE = "\n";


    private function __construct()
    {

    }


    public static function new() : static
    {
        return new static();
    }


    public function run() : void
    {
        global $argv;

        $folder = $argv[1] ?? "";
        if (empty($folder)) {
            echo "Please pass a folder" . static::NEW_LINE;
            die(1);
        }

        $from_namespace = $this->normalizeNamespace(
            $argv[2] ?? ""
        );
        if (empty($from_namespace)) {
            echo 'Please pass a "from namespace"' . static::NEW_LINE;
            die(1);
        }

        $to_namespace = $this->normalizeNamespace(
            $argv[3] ?? ""
        );
        if (empty($to_namespace)) {
            echo 'Please pass a "to namespace"' . static::NEW_LINE;
            die(1);
        }

        echo "Change namespace " . $from_namespace . " to " . $to_namespace . static::NEW_LINE . static::NEW_LINE;

        $EXT = [
            "json",
            "md",
            "php",
            "xml",
            "yml",
            "yaml"
        ];

        $REPLACES = [
            $from_namespace => $to_namespace
        ];
        if (str_contains($from_namespace, "\\")) {
            $REPLACES[str_replace("\\", "\\\\", $from_namespace)] = str_replace("\\", "\\\\", $to_namespace);
        }

        foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS)) as $file) {
            if (!$file->isFile()) {
                continue;
            }

            if (!in_array(strtolower(pathinfo($file->getFileName(), PATHINFO_EXTENSION)), $EXT)) {
                continue;
            }

            $code = $old_code = file_get_contents($file->getPathName());

            foreach ($REPLACES as $search => $replace) {
                if (!str_contains($code, $replace)) {
                    $code = str_replace($search, $replace, $code);
                }
            }

            if ($old_code !== $code) {
                echo "Store " . $file->getPathName() . static::NEW_LINE;
                file_put_contents($file->getPathName(), $code);
            }
        }

        echo static::NEW_LINE;
    }


    private function normalizeNamespace(string $namespace) : string
    {
        return trim($namespace, "\\");
    }
}
