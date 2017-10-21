<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

    $smarty = new SmartyInit('http');
    $dbReport = new PRReports($smarty->connection);
    $template_prefix = "json";
    header('Content-Type: application/json');
    
    function get_property($smarty, $dbReport) {
        
    }