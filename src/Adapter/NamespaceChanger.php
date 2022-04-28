<?php

namespace FluxNamespaceChanger\Adapter;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;

class NamespaceChanger
{

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

        $folder = $argv[1];
        if (empty($folder)) {
            echo "Please pass a folder\n";
            die(1);
        }

        $from_namespace = $this->normalizeNamespace(
            $argv[2] ?? ""
        );
        if (empty($from_namespace)) {
            echo "Please pass a \"from namespace\"\n";
            die(1);
        }

        $to_namespace = $this->normalizeNamespace(
            $argv[3] ?? ""
        );
        if (empty($to_namespace)) {
            echo "Please pass a \"to namespace\"\n";
            die(1);
        }

        echo "Change namespace " . $from_namespace . " to " . $to_namespace . "\n";

        $replaces = [
            $from_namespace => $to_namespace
        ];
        if (str_contains($from_namespace, "\\")) {
            $replaces[str_replace("\\", "\\\\", $from_namespace)] = str_replace("\\", "\\\\", $to_namespace);
        }

        $ext = [
            "json",
            "md",
            "php",
            "xml",
            "yml",
            "yaml"
        ];

        foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($folder, RecursiveDirectoryIterator::SKIP_DOTS)) as $file) {
            if (!$file->isFile()) {
                continue;
            }

            if (!in_array(strtolower(pathinfo($file->getFileName(), PATHINFO_EXTENSION)), $ext)) {
                continue;
            }

            $code = $old_code = file_get_contents($file->getPathName());

            foreach ($replaces as $search => $replace) {
                if (!str_contains($code, $replace)) {
                    $code = str_replace($search, $replace, $code);
                }
            }

            if ($old_code !== $code) {
                echo "Store " . $file->getPathName() . "\n";
                file_put_contents($file->getPathName(), $code);
            }
        }
    }


    private function normalizeNamespace(string $namespace) : string
    {
        return trim($namespace, "\\");
    }
}
