<?php
// PHPExcel libraries
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php';
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel/IOFactory.php';

class PropertyDownloader {
    /**
     * @var null | PHPExcel
     */
    private $_oPHPExcel        = NULL;

    /**
     * @var null | PHPExcel_Reader_IReader
     */
    private $_oReader          = NULL;

    /**
     * @var null
     */
    private $_oWriter          = NULL;

    /**
     * @var array
     */
    private $_aPropertyData    = array();


    // ------------------------------------------------------------------------
    /**
     * Load template Excel document.
     */
    public function __construct($templateFileName, $data)
    {
        $inputFileType        = PHPExcel_IOFactory::identify($templateFileName);
        $this->_oReader       = PHPExcel_IOFactory::createReader($inputFileType);
        $this->_oPHPExcel     = $this->_oReader->load($templateFileName);
        $this->_aPropertyData = $data;

        $this->_generatePropertiesSheet();
        $this->_generateEstimatesSheet();
    }

    // ------------------------------------------------------------------------
    /**
     * Populate "Properties" sheet.
     */
    private function _generatePropertiesSheet()
    {
        $objWorksheet = $this->_oPHPExcel->getSheetByName("Properties");
        $baseRow      = 5;
        $eBaseRow     = 10;

        $objDrawing = new PHPExcel_Worksheet_Drawing();
        $objDrawing->setName('Logo');
        $objDrawing->setDescription('Logo');
        $objDrawing->setPath(realpath(TEMPLATE_DIR.'/').'/'.'logo.jpg');
        $objDrawing->setWorksheet($objWorksheet);
        $objDrawing->setCoordinates('A1');
         
        //clean worksheet
        $objWorksheet->removeRow($baseRow, $objWorksheet->getHighestDataRow());

        //populate worksheet with new data
        foreach($this->_aPropertyData as $r => $dataRow)
        {
            $row = $baseRow + $r;
            $erow = $eBaseRow + $r;
            $objWorksheet->insertNewRowBefore($row, 1);
            $objWorksheet->getStyle('A'.$row.':J'.$row)->getFont()->setBold(false);

            $objWorksheet->setCellValue('A'.$row, $dataRow['ADDRESS1']); //Address1
            $objWorksheet->getStyle('A'.$row)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLACK);
            if ( ! empty($dataRow['PROP_ID']) )
            {
                $objWorksheet->getCell('A'.$row)->getHyperlink()->setUrl('http://visulate.com/property/'.$dataRow['PROP_ID']);
                $objWorksheet->getCell('A'.$row)->getHyperlink()->setTooltip('Navigate to website');
                $objWorksheet->getStyle('A'.$row)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLUE);
            }
            $objWorksheet->setCellValue('B'.$row, $dataRow['ADDRESS2']); //Address2
            $objWorksheet->setCellValue('C'.$row, $dataRow['CITY']); //City
            $objWorksheet->setCellValue('D'.$row, $dataRow['STATE']); //State
            $objWorksheet->setCellValue('E'.$row, $dataRow['ZIPCODE']); //Zip Code
            $objWorksheet->setCellValue('F'.$row, $dataRow['YEAR_BUILT']); //Year Built
            $objWorksheet->setCellValue('G'.$row, $dataRow['BUILDING_SIZE']); //Building Size
            $objWorksheet->getStyle('G'.$row)->getNumberFormat()->setFormatCode('#,##0');
            $objWorksheet->setCellValue('H'.$row, $dataRow['UNITS']); //Units
            $objWorksheet->setCellValue('I'.$row, $dataRow['TOTAL_BEDS']); //Bedrooms
            $objWorksheet->setCellValue('J'.$row, $dataRow['TOTAL_BATHS']); //Bathrooms
            $objWorksheet->setCellValue('K'.$row, "='Estimates'!L".$erow); //Market Value
            $objWorksheet->getStyle('K'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
            $objWorksheet->getStyle('K'.$row)->getFont()->setBold(false);
            $objWorksheet->setCellValue('L'.$row, "='Estimates'!B".$erow); //Suggested Rent
            $objWorksheet->getStyle('L'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
            $objWorksheet->setCellValue('M'.$row, "=K".$row."/(12*L".$row.")"); //GRM
            $objWorksheet->setCellValue('N'.$row, "=(12*L".$row.")/K".$row); //Gross Yield
            $objWorksheet->getStyle('M'.$row)->getNumberFormat()->setFormatCode('0.00');
            $objWorksheet->getStyle('M'.$row)->getFont()->setBold(false);
            $objWorksheet->getStyle('N'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
            $objWorksheet->getStyle('N'.$row)->getFont()->setBold(false);
            $objWorksheet->setCellValue('O'.$row, "='Estimates'!J".$erow); //Projected NOI
            $objWorksheet->getStyle('O'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
            $objWorksheet->setCellValue('P'.$row, "='Estimates'!K".$erow); //Income Value
            $objWorksheet->getStyle('P'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
            $objWorksheet->getStyle('P'.$row)->getFont()->setBold(false);
            $objWorksheet->setCellValue('Q'.$row, "='Estimates'!V".$erow); //IRR
            $objWorksheet->getStyle('Q'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);

        }

     //   $objWorksheet->getProtection()->setSheet(true);
     //   $objWorksheet->getProtection()->setPassword("PHPExcel");
    }

    // ------------------------------------------------------------------------
    /**
     * Populate "Estimates" sheet
     */
    private function _generateEstimatesSheet()
    {
        $objWorksheet = $this->_oPHPExcel->getSheetByName("Estimates");

        $currYear = (int)date("Y");

        //set period
        $objWorksheet->getStyle('N9:S9')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_GENERAL);
        $objWorksheet->setCellValue('N9', $currYear++);
        $objWorksheet->setCellValue('O9', $currYear++);
        $objWorksheet->setCellValue('P9', $currYear++);
        $objWorksheet->setCellValue('Q9', $currYear++);
        $objWorksheet->setCellValue('R9', $currYear++);
        $objWorksheet->setCellValue('S9', $currYear);

        //clean worksheet and save 1 row as template for new rows
        $baseRow = $row = 10;
        $objWorksheet->removeRow($baseRow, $objWorksheet->getHighestDataRow());

        foreach($this->_aPropertyData as $r => $dataRow)
        {
            $objWorksheet->insertNewRowBefore($row, 1);
            $objWorksheet->getStyle('A'.$row.':V'.$row)->getFont()->setBold(false);
            $objWorksheet->getStyle('B'.$row.':U'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
            $objWorksheet->getStyle('V'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);

            $objWorksheet->setCellValue('A'.$row, $dataRow['ADDRESS1']); //Address1

            foreach ($dataRow['estimates'] as $i => $estimate)
            {
            /* Show only the first estimate for a property if it has more than one
                if ($i > 0) {
                    $objWorksheet->insertNewRowBefore(++$row, 1);
                }
            */
              if ($i == 0) {
                $objWorksheet->setCellValue('B'.$row, $estimate['MONTHLY_RENT']);  //Rent/Mo
                $objWorksheet->setCellValue('C'.$row, '=B'.$row.'*12');            //Rent/Yr
                $objWorksheet->setCellValue('D'.$row, '=C'.$row.'*$B$1');          //Vacancies
                $objWorksheet->setCellValue('E'.$row, $estimate['MAINTENANCE']);   //Maintenance
                $objWorksheet->setCellValue('F'.$row, $estimate['UTILITIES']);     //Utilities
                $objWorksheet->setCellValue('G'.$row, $estimate['PROPERTY_TAXES']);//Prop Tax
                $objWorksheet->setCellValue('H'.$row, $estimate['INSURANCE']);     //Insurance
                $objWorksheet->setCellValue('I'.$row, '=C'.$row.'*0.1');           //Mgt Fees
                $objWorksheet->setCellValue('J'.$row, '=C'.$row.'-D'.$row.'-E'.$row.
                                                      '-F'.$row.'-G'.$row.'-H'.$row.'-I'.$row); //NOI
                $objWorksheet->setCellValue('K'.$row, '=J'.$row.'/$B$2');          //Income Value
                $objWorksheet->getStyle('K'.$row)->getFont()->setBold(true);
                $objWorksheet->setCellValue('L'.$row, $estimate['PURCHASE_PRICE']);//Market Value
                $objWorksheet->getStyle('L'.$row)->getFont()->setBold(true);
                $objWorksheet->setCellValue('M'.$row, '=$B$3*'.$dataRow['BUILDING_SIZE']); //Rehab
                $objWorksheet->setCellValue('N'.$row, '=-(L'.$row.'+M'.$row.')');      //Cash Invested
                $objWorksheet->setCellValue('O'.$row, '=J'.$row);  //Year 1
                $objWorksheet->setCellValue('P'.$row, '=J'.$row);  //Year 2
                $objWorksheet->setCellValue('Q'.$row, '=J'.$row);  //Year 3
                $objWorksheet->setCellValue('R'.$row, '=J'.$row);  //Year 4
                $objWorksheet->setCellValue('S'.$row, '=J'.$row.'+T'.$row.'+U'.$row);  //Year 5
                $objWorksheet->setCellValue('T'.$row, '=FV($B$5,5,0,0-L'.$row.',0)'); //Sale Price
                $objWorksheet->getStyle('T'.$row)->getFont()->setBold(true);
                $objWorksheet->setCellValue('U'.$row, '=0-(T'.$row.'*$B$6)');       //Sale Costs
                $objWorksheet->setCellValue('V'.$row, '=IRR(N'.$row.':S'.$row.',0.1)'); //5 Year IRR
                $objWorksheet->getStyle('V'.$row)->getFont()->setBold(true);
              }
            }
            $row++;
        }

        //add totals
        $objWorksheet->setCellValue('A'.$row, 'Total'); //Total
        $objWorksheet->setCellValue('B'.$row, '=SUM(B'.$baseRow.':B'.($row - 1).')'); //Rent/Mo
        $objWorksheet->setCellValue('C'.$row, '=SUM(C'.$baseRow.':C'.($row - 1).')'); //Rent/Yr
        $objWorksheet->setCellValue('D'.$row, '=SUM(D'.$baseRow.':D'.($row - 1).')'); //Vacancies
        $objWorksheet->setCellValue('E'.$row, '=SUM(E'.$baseRow.':E'.($row - 1).')'); //Maintenance
        $objWorksheet->setCellValue('F'.$row, '=SUM(F'.$baseRow.':F'.($row - 1).')'); //Utilities
        $objWorksheet->setCellValue('G'.$row, '=SUM(G'.$baseRow.':G'.($row - 1).')'); //Prop Tax
        $objWorksheet->setCellValue('H'.$row, '=SUM(H'.$baseRow.':H'.($row - 1).')'); //Insurance
        $objWorksheet->setCellValue('I'.$row, '=SUM(I'.$baseRow.':I'.($row - 1).')'); //Mgt Fees
        $objWorksheet->setCellValue('J'.$row, '=SUM(J'.$baseRow.':J'.($row - 1).')'); //NOI
        $objWorksheet->setCellValue('K'.$row, '=SUM(K'.$baseRow.':K'.($row - 1).')'); //Income Value
        $objWorksheet->setCellValue('L'.$row, '=SUM(L'.$baseRow.':L'.($row - 1).')'); //Market Value
        $objWorksheet->setCellValue('M'.$row, '=SUM(M'.$baseRow.':M'.($row - 1).')'); //Purchase
        $objWorksheet->setCellValue('N'.$row, '=SUM(N'.$baseRow.':N'.($row - 1).')'); //Repair Cost
        $objWorksheet->setCellValue('O'.$row, '=SUM(O'.$baseRow.':O'.($row - 1).')'); //Year 1
        $objWorksheet->setCellValue('P'.$row, '=SUM(P'.$baseRow.':P'.($row - 1).')'); //Year 2
        $objWorksheet->setCellValue('Q'.$row, '=SUM(Q'.$baseRow.':Q'.($row - 1).')'); //Year 3
        $objWorksheet->setCellValue('R'.$row, '=SUM(R'.$baseRow.':R'.($row - 1).')'); //Year 4
        $objWorksheet->setCellValue('S'.$row, '=SUM(S'.$baseRow.':S'.($row - 1).')'); //Year 5
        $objWorksheet->setCellValue('T'.$row, '=SUM(T'.$baseRow.':T'.($row - 1).')'); //Sale
        $objWorksheet->setCellValue('U'.$row, '=SUM(U'.$baseRow.':U'.($row - 1).')'); //Sale Costs
        $objWorksheet->setCellValue('V'.$row, '=AVERAGE(V'.$baseRow.':V'.($row - 1).')'); //5 Year IRR

        //set format of cells with currencies
        $objWorksheet->getStyle('B'.$row.':U'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->getStyle('V'.$row)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);

        //set format of cells with totals
        $objWorksheet->getStyle('A'.$row.':V'.$row)->getFont()->setBold(true);
    }

    // ------------------------------------------------------------------------
    /**
     * Download spreadsheet in XLS format.
     */
    public function getXLS()
    {
        // Set active sheet index to the first sheet, so Excel opens this as the first sheet
        $this->_oPHPExcel->setActiveSheetIndex(0);
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="address2irr.xls"');
        header('Cache-Control: max-age=0');

        $this->_oWriter = PHPExcel_IOFactory::createWriter($this->_oPHPExcel, 'Excel5');
        $this->_oWriter->setPreCalculateFormulas(false);
        $this->_oWriter->save('php://output');
        exit;
    }

    // ------------------------------------------------------------------------
    /**
     * Download spreadsheet in XLSX format.
     */
    public function getXLSX()
    {
        // Set active sheet index to the first sheet, so Excel opens this as the first sheet
        $this->_oPHPExcel->setActiveSheetIndex(0);

        // Redirect output to a client’s web browser (Excel2007)
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="address2irr.xlsx"');
        header('Cache-Control: max-age=0');

        $this->_oWriter = PHPExcel_IOFactory::createWriter($this->_oPHPExcel, 'Excel2007');
        $this->_oWriter->setPreCalculateFormulas(false);
        $this->_oWriter->save('php://output');
        exit;
    }

    private function writeLog($message='')
    {
        $filename = str_replace('.php', '.txt', __FILE__);
        if ( ! $fp = @fopen($filename, 'a'))
        {
            return FALSE;
        }

        flock($fp, LOCK_EX);
        fwrite($fp, $message);
        flock($fp, LOCK_UN);
        fclose($fp);
    }
}
