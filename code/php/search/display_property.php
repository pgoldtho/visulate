<?php

function display_property($smarty, $template_prefix, $dbReport) {
    $is_editor = $smarty->user->isBuyer();
    $prop_id = htmlentities($_REQUEST["PROP_ID"], ENT_QUOTES);
    $href = $GLOBALS["PATH_FORM_ROOT"] . "visulate_search.php?REPORT_CODE=PROPERTY_DETAILS&PROP_ID=$prop_id";

    $submenu3 = array(array("href" => $href, "value" => "Property"),
        array("href" => $href . "&MODE=location", "value" => "Neighborhood Information"),
        array("href" => $href . "&MODE=cashflow", "value" => "Cashflow Estimate"));

    $report_data = $dbReport->getPropertyDetails($prop_id);
    $smarty->assign("data", $report_data);



    $type = (htmlentities($_REQUEST["MODE"], ENT_QUOTES));
    switch ($type) {
        case "location":
            $skey = 1;
            location_details($smarty, $prop_id, $report_data, $dbReport);
            break;
        case "cashflow":
            $skey = 2;
            cashflow_details($smarty, $prop_id, $report_data, $dbReport);
            break;
        default:
            $skey = 0;
            property_details($smarty, $prop_id, $report_data, $dbReport);
    }



    $canonical = 'property/' . $prop_id;
    $smarty->assign("canonical", $canonical);

    if ($is_editor) {
        require_once dirname(__FILE__) . "/classes/database/rnt_business_units.class.php";

        $smarty->user->set_database_user();
        $dbBU = new RNTBusinessUnit($smarty->connection);
        $buList = $dbBU->getBusinessUnitByRole('BUYER');

        $smarty->assign("buList", $buList);
    }
    $smarty->assign("isEditor", $is_editor);


    $display_property = $report_data["PROPERTY"]["ADDRESS1"] . ", " . $report_data["PROPERTY"]["CITY"]
            . ", " . $report_data["PROPERTY"]["STATE"];
    $smarty->assign("pageTitle", "$display_property - Visulate");

    $smarty->assign("submenu2_1", $submenu3);
    $smarty->assign("skey", $skey);

    $html_report = $smarty->display($template_prefix . "-property-details.tpl");
}

function property_details($smarty, $prop_id, $report_data, $dbReport) {
    $streetview = $dbReport->get_streetview_url($report_data["PROPERTY"]["LAT"], $report_data["PROPERTY"]["LON"]);
    $smarty->assign("streetview", $streetview);

    $mls = $dbReport->getMLS($prop_id);
    $smarty->assign("mls", $mls);

    $prop_desc = $report_data["PROPERTY"]["ADDRESS1"] . " is a "
            . number_format($report_data["PROPERTY"]["SQ_FT"]) . " sq ft " . $usage;


    if ($report_data["PROPERTY"]["ADDRESS1"] == "1600 Pennsylvania Avenue NW") {
        $prop_desc = "404 Not Found";
    }

    $smarty->assign("pageDesc", "$prop_desc");
}

function location_details($smarty, $prop_id, $report_data, $dbReport) {
    $comps = $dbReport->getSimilar($prop_id);
    $mls_listings = $dbReport->getSimilarMLS($prop_id);

    $smarty->assign("comps", $comps);
    $smarty->assign("mls_listings", $mls_listings);


    if ($report_data["PROPERTY"]["PUMA"]) {
        $dbSearch = new LISTSearch($smarty->connection);
        $puma = $dbSearch->getPumaSummary($report_data["PROPERTY"]["PUMA"]);
        $smarty->assign("puma", $puma);
    }
}

function cashflow_details($smarty, $prop_id, $report_data, $dbReport) {

    $lease_type = $dbReport->getLeaseType($prop_id);
    $smarty->assign("lease_type", $lease_type);

    $ucode = 90001;
    foreach ($report_data["PROPERTY_USAGE"] as $k => $v) {
        $ucode = $k;
        $usage = $v;
    }

    $default_values = $dbReport->getDefaults($prop_id, $ucode);
    foreach ($default_values as $k => $v) {
        if ($lease_type == 'Triple Net') {
            $default_values[$k]["INSURANCE"] = $default_values[$k]["INSURANCE"] * $default_values[$k]["VACANCY_PERCENT"] / 100;
            $default_values[$k]["MAINTENANCE"] = $default_values[$k]["MAINTENANCE"] * $default_values[$k]["VACANCY_PERCENT"] / 100;
            $default_values[$k]["UTILITIES"] = $default_values[$k]["UTILITIES"] * $default_values[$k]["VACANCY_PERCENT"] / 100;
            $default_values[$k]["TAX"] = $default_values[$k]["TAX"] * $default_values[$k]["VACANCY_PERCENT"] / 100;
        }

        $default_values[$k]["NOI"] = round(($default_values[$k]["ANNUAL_RENT"] - $default_values[$k]["VACANCY_AMOUNT"] - $default_values[$k]["INSURANCE"] - $default_values[$k]["MAINTENANCE"] - $default_values[$k]["UTILITIES"] - $default_values[$k]["TAX"] - $default_values[$k]["MGT_AMOUNT"]));
        $default_values[$k]["VALUE"] = round($default_values[$k]["NOI"] / $default_values[$k]["CAP_RATE"] * 100);
        $default_values[$k]["DOWN"] = round($default_values[$k]["VALUE"] * 25 / 100);
        $default_values[$k]["LOAN"] = round($default_values[$k]["VALUE"] * 75 / 100);
        $default_values[$k]["COSTS"] = round($default_values[$k]["VALUE"] * 4 / 100);
    }
    $smarty->assign("defaults", $default_values);

    $pclass = $default_values["A"]["PCLASS"];
    $smarty->assign("p_class", $pclass);
    $smarty->assign("pvalues", $default_values[$pclass]);

    $prop_desc = "Interactive worksheet for " . $report_data["PROPERTY"]["ADDRESS1"]
            . ".  Estimate its net operating income, unleveraged yield, finance costs, cashflow and cash on cash return."
            . " Download a spreadsheet to estimate a 5 year IRR.";
    if ($default_values[$pclass]["VALUE"] == 0) {
        $prop_desc = "Address: " . $report_data["PROPERTY"]["ADDRESS1"]
                . ", Acreage: " . number_format($report_data["PROPERTY"]["ACREAGE"], 2)
                . ", Latitude: " . number_format($report_data["PROPERTY"]["LAT"], 2)
                . ", Longitude: " . number_format($report_data["PROPERTY"]["LON"], 2);
    } elseif ($lease_type == 'Triple Net' && ($report_data["PROPERTY"]["SQ_FT"] > 0)) {
        $prop_desc = $report_data["PROPERTY"]["ADDRESS1"] . " is a " . number_format($report_data["PROPERTY"]["SQ_FT"]) . " sq ft " . $usage
                . ". We estimate it will lease for $" . number_format($default_values[$pclass]["ANNUAL_RENT"] / $report_data["PROPERTY"]["SQ_FT"])
                . "/ft and have an NOI of $" . number_format($default_values[$pclass]["NOI"])
                . "/year giving it an income Value of $" . number_format($default_values[$pclass]["VALUE"])
                . ". Its market value in " . $default_values[$pclass]["YEAR"]
                . " was $" . number_format($default_values[$pclass]["MEDIAN_MARKET_VALUE"]);
    }
    $smarty->assign("pageDesc", "$prop_desc");
}

function display_owner($smarty, $template_prefix, $dbReport) {
    $display_owner = htmlentities($_REQUEST["OWNER_ID"], ENT_QUOTES);
    $report_data = $dbReport->getOwnerDetails(htmlentities($_REQUEST["OWNER_ID"], ENT_QUOTES));
    $smarty->assign("data", $report_data);
    $smarty->assign("pageTitle", "Property Owner Details: $display_owner");
    $smarty->assign("pageDesc", "Property owner details as recorded in tax records.");
    $html_report = $smarty->display($template_prefix . "-owner-details.tpl");
}

function save2BU($smarty) {
    $form = new HTML_QuickForm('Save2BU', 'POST');
    $post_values = $form->getSubmitValues();
    $values = array();

    $values["PROP_ID"] = htmlentities($post_values["PROP_ID"], ENT_QUOTES);
    $values["BUSINESS_ID"] = htmlentities($post_values["BUSINESS_ID"], ENT_QUOTES);
    $values["ESTIMATE_TITLE"] = htmlentities($post_values["ESTIMATE_TITLE"], ENT_QUOTES);
    $values["MONTHLY_RENT"] = htmlentities(str_replace(",", "", $post_values["MONTHLY_RENT"]), ENT_QUOTES);
    $values["OTHER_INCOME"] = htmlentities(str_replace(",", "", $post_values["OTHER_INCOME"]), ENT_QUOTES);
    $values["VACANCY_PCT"] = htmlentities(str_replace(",", "", $post_values["VACANCY_PCT"]), ENT_QUOTES);
    $values["REPLACE_3YEARS"] = htmlentities(str_replace(",", "", $post_values["REPLACE_3YEARS"]), ENT_QUOTES);
    $values["REPLACE_5YEARS"] = htmlentities(str_replace(",", "", $post_values["REPLACE_5YEARS"]), ENT_QUOTES);
    $values["REPLACE_12YEARS"] = htmlentities(str_replace(",", "", $post_values["REPLACE_12YEARS"]), ENT_QUOTES);
    $values["MAINTENANCE"] = htmlentities(str_replace(",", "", $post_values["MAINTENANCE"]), ENT_QUOTES);
    $values["UTILITIES"] = htmlentities(str_replace(",", "", $post_values["UTILITIES"]), ENT_QUOTES);
    $values["PROPERTY_TAXES"] = htmlentities(str_replace(",", "", $post_values["PROPERTY_TAXES"]), ENT_QUOTES);
    $values["INSURANCE"] = htmlentities(str_replace(",", "", $post_values["INSURANCE"]), ENT_QUOTES);
    $values["MGT_FEES"] = htmlentities(str_replace(",", "", $post_values["MGT_FEES"]), ENT_QUOTES);
    $values["DOWN_PAYMENT"] = htmlentities(str_replace(",", "", $post_values["DOWN_PAYMENT"]), ENT_QUOTES);
    $values["CLOSING_COSTS"] = htmlentities(str_replace(",", "", $post_values["CLOSING_COSTS"]), ENT_QUOTES);
    $values["PURCHASE_PRICE"] = htmlentities(str_replace(",", "", $post_values["PURCHASE_PRICE"]), ENT_QUOTES);
    $values["CAP_RATE"] = htmlentities(str_replace(",", "", $post_values["CAP_RATE"]), ENT_QUOTES);
    $values["LOAN1_AMOUNT"] = htmlentities(str_replace(",", "", $post_values["LOAN1_AMOUNT"]), ENT_QUOTES);
    $values["LOAN1_TYPE"] = htmlentities(str_replace(",", "", $post_values["LOAN1_TYPE"]), ENT_QUOTES);
    $values["LOAN1_TERM"] = htmlentities(str_replace(",", "", $post_values["LOAN1_TERM"]), ENT_QUOTES);
    $values["LOAN1_RATE"] = htmlentities(str_replace(",", "", $post_values["LOAN1_RATE"]), ENT_QUOTES);
    $values["LOAN2_AMOUNT"] = htmlentities(str_replace(",", "", $post_values["LOAN2_AMOUNT"]), ENT_QUOTES);
    $values["LOAN2_TYPE"] = htmlentities(str_replace(",", "", $post_values["LOAN2_TYPE"]), ENT_QUOTES);
    $values["LOAN2_TERM"] = htmlentities(str_replace(",", "", $post_values["LOAN2_TERM"]), ENT_QUOTES);
    $values["LOAN2_RATE"] = htmlentities(str_replace(",", "", $post_values["LOAN2_RATE"]), ENT_QUOTES);

    $is_editor = $smarty->user->isBuyer();
    if ($is_editor) {
        require_once dirname(__FILE__) . "/classes/database/rnt_business_units.class.php";
        require_once dirname(__FILE__) . "/classes/database/rnt_estimate.class.php";

        $smarty->user->set_database_user();
        $dbBU = new RNTBusinessUnit($smarty->connection);
        $buList = $dbBU->getBusinessUnitByRole('BUYER');
        $hasAccess = false;
        foreach ($buList as $k => $v) {
            if ($buList[$k]["BUSINESS_ID"] == $values["BUSINESS_ID"])
                $hasAccess = true;
        }
        if ($hasAccess) {
            $dbEstimate = new RNTEstimate($smarty->connection);
            $return_code = $dbEstimate->save2BU($values);
            if ($return_code == '1')
                $message = 'Saved property to business unit';
            elseif ($return_code == '2')
                $message = 'Updated existing estimate in business unit';
            elseif ($return_code == '10')
                $message = 'Added estimate to existing property in business unit';
            elseif ($return_code == '11')
                $message = 'Saved property and estimate to business unit';
            else
                $message = '<span class="error"> Save failed.  A database error occurred</span>';
        }
        else {
            $message = '<span class="error"> Save failed.  You do not have access to the selected business unit</span>';
        }
    } else {
        $message = '<span class="error"> Save failed.  You are not logged in with a role of buyer</span>';
    }

    $smarty->assign("skey", "1");
    $smarty->assign("save2BUmsg", $message);
}
