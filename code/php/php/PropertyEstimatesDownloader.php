<?php
// PHPExcel libraries
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php';
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel/IOFactory.php';

/**
 * Property Estimates spreadsheet downloader.
 */
class PropertyEstimatesDownloader
{
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

    private $_aPropertyData    = array();

    /**
     * @param string $templateFileName
     * @param array  $data
     */
    public function __construct($templateFileName, $data)
    {
        $inputFileType        = PHPExcel_IOFactory::identify($templateFileName);
        $this->_oReader       = PHPExcel_IOFactory::createReader($inputFileType);
        $this->_oPHPExcel     = $this->_oReader->load($templateFileName);
        $this->_aPropertyData = $data;

        $this->_generatePropertiesSheet();
    }

    // ------------------------------------------------------------------------
    /**
     * Populate "Properties" sheet.
     */
    private function _generatePropertiesSheet()
    {
        $objWorksheet = $this->_oPHPExcel->getSheet(0);

        // Print logo
        $objDrawing = $objWorksheet->getDrawingCollection()->offsetGet(0);
        if (empty($objDrawing)) {
            $objDrawing = new PHPExcel_Worksheet_Drawing();
            $objDrawing->setWorksheet($objWorksheet);
        }
        $objDrawing->setName('Logo');
        $objDrawing->setDescription('Logo');
        $objDrawing->setPath(realpath(TEMPLATE_DIR.'/').'/'.'logo.jpg');
        $objDrawing->setCoordinates('A1');

        // Print property info
        $row = 3;
        $objWorksheet->setCellValue('A'.$row, $this->_aPropertyData['PROP_ADDRESS1']); //Address1
        $objWorksheet->getStyle('A'.$row)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLACK);
        if ( ! empty($this->_aPropertyData['PROP_PROP_ID']) )
        {
            $objWorksheet->getCell('A'.$row)->getHyperlink()->setUrl('http://visulate.com/property/'.$this->_aPropertyData['PROP_PROP_ID']);
            $objWorksheet->getCell('A'.$row)->getHyperlink()->setTooltip('Navigate to website');
            $objWorksheet->getStyle('A'.$row)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLUE);
        }
        $objWorksheet->setCellValue('B'.$row, $this->_aPropertyData['PROP_ADDRESS2']); //Address2
        $objWorksheet->setCellValue('C'.$row, $this->_aPropertyData['PROP_CITY']); //City
        $objWorksheet->setCellValue('D'.$row, $this->_aPropertyData['PROP_STATE']); //State
        $objWorksheet->setCellValue('E'.$row, $this->_aPropertyData['PROP_ZIPCODE']); //Zip Code
        $objWorksheet->setCellValue('G'.$row, $this->_aPropertyData['PROP_YEAR_BUILT']); //Year Built
        $objWorksheet->setCellValue('H'.$row, $this->_aPropertyData['PROP_BUILDING_SIZE']); //Building Size

        $objWorksheet->setCellValue('G1', $this->_aPropertyData['PROP_ADDRESS1'].', '.
                       $this->_aPropertyData['PROP_CITY'].', '.$this->_aPropertyData['PROP_STATE'].
                       '. Pro-Forma Income, Cash Flow and IRR Estimates.');
         $objWorksheet->getStyle('G1')->getAlignment()->setWrapText(true)->setVertical(PHPExcel_Style_Alignment::VERTICAL_TOP);


        // Left side
        $objWorksheet->setCellValue('B5', $this->_aPropertyData['PROP_ESTIMATE']['MONTHLY_RENT']); //Monthly Rent
        $objWorksheet->setCellValue('B6', '=B5*12'); //Annual Rent
        $objWorksheet->setCellValue('B7', '=B6/H3'); //Gross Rent/Ft
        $objWorksheet->setCellValue('B8', $this->_aPropertyData['PROP_ESTIMATE']['OTHER_INCOME']); //Other Income
        $objWorksheet->setCellValue('B9', '=(B5*12)+B8'); //Potential Gross Income
        $objWorksheet->setCellValue('B11', '=B5*12*E5'); //Vacancy Amount
        $objWorksheet->setCellValue('B12', $this->_aPropertyData['PROP_ESTIMATE']['REPLACE_3YEARS']); //3 Year Replacements
        $objWorksheet->setCellValue('B13', $this->_aPropertyData['PROP_ESTIMATE']['REPLACE_5YEARS']); //5 Year Replacements
        $objWorksheet->setCellValue('B14', $this->_aPropertyData['PROP_ESTIMATE']['REPLACE_12YEARS']); //12 Year Replacements
        $objWorksheet->setCellValue('B15', '=(B12/3)+(B13/5)+(B14/12)'); //Reserve Fund
        $objWorksheet->setCellValue('B16', $this->_aPropertyData['PROP_ESTIMATE']['MAINTENANCE']); //Maintenance
        if ($this->_aPropertyData['PROP_ESTIMATE']['UTILITIES'])
          $objWorksheet->setCellValue('B17', $this->_aPropertyData['PROP_ESTIMATE']['UTILITIES']); //Utilities
        else
         $objWorksheet->setCellValue('B17',"0");
        $objWorksheet->setCellValue('B18', $this->_aPropertyData['PROP_ESTIMATE']['PROPERTY_TAXES']); //Property Taxes
        $objWorksheet->setCellValue('B19', $this->_aPropertyData['PROP_ESTIMATE']['INSURANCE']); //Insurance
        $objWorksheet->setCellValue('B20', '=B9*E6'); //Management Fees
        $objWorksheet->setCellValue('B24', "Residential/Gross"); //Lease Type
        $objWorksheet->setCellValue('B21', '=IF(B24="NNN",(B11+B15+B20+(B16+B17+B18+B19)*E5),B11+B15+B16+B17+B18+B19+B20)'); //Total Expenses
        //$objWorksheet->setCellValue('B21','=B11+B15+B16+B17+B18+B19+B20');
        $objWorksheet->setCellValue('B22', '=B9-B21'); //Net Operating Income
        $objWorksheet->getStyle('B5:B22')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->getStyle('B7')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD_SIMPLE);

        
        $objWorksheet->setCellValue('B25', '=B21/B9'); //Expense Ratio
        
        $objWorksheet->setCellValue('B27', '=B22/E7'); //Market Value
        $objWorksheet->setCellValue('B28', '=B9/B27'); //Gross Yield
        $objWorksheet->setCellValue('B29', '=B22/B27'); //Net Yield

        // Center side
        $objWorksheet->setCellValue('E5', ($this->_aPropertyData['PROP_ESTIMATE']['VACANCY_PCT'])/100); //Vacancy and Bad Dept Percent
        $objWorksheet->getStyle('E5')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
        $objWorksheet->setCellValue('E7', ($this->_aPropertyData['PROP_ESTIMATE']['CAP_RATE'])/100); //Desired Cap Rate
        $objWorksheet->getStyle('E7')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
        $objWorksheet->setCellValue('E11', '=B22/E7'); //Purchase Price
        $objWorksheet->setCellValue('E12', $this->_aPropertyData['PROP_ESTIMATE']['DOWN_PAYMENT']); //Down Payment
        $objWorksheet->setCellValue('E13', $this->_aPropertyData['PROP_ESTIMATE']['CLOSING_COSTS']); //Closing Costs
        $objWorksheet->setCellValue('E14', '=E11-E12'); //Finance Amount
        $objWorksheet->setCellValue('E15', '=E10+E12+E13'); //Cash Invested
        $objWorksheet->getStyle('E11:E15')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);

        $objWorksheet->setCellValue('E17', '=E14'); //First Loan Amount
        $objWorksheet->getStyle('E17')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('E18', $this->_aPropertyData['PROP_ESTIMATE']['LOAN1_TYPE']); // Loan1 Type
        $objWorksheet->setCellValue('E19', ($this->_aPropertyData['PROP_ESTIMATE']['LOAN1_RATE']/100)); //Interest Rate
        $objWorksheet->getStyle('E19')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
        $objWorksheet->setCellValue('E20', $this->_aPropertyData['PROP_ESTIMATE']['LOAN1_TERM']); //Amortization Term
        $objWorksheet->setCellValue('E21', '=IF(E18="Amortizing",PMT(E19/12,E20*12,E17,0,0),-E17*E19/12)'); //Monthly Payment
        $objWorksheet->getStyle('E21')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);

        $objWorksheet->setCellValue('E23', $this->_aPropertyData['PROP_ESTIMATE']['LOAN2_AMOUNT']); //Second Loan Amount
        $objWorksheet->getStyle('E23')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('E24', $this->_aPropertyData['PROP_ESTIMATE']['LOAN2_TYPE']); // Loan2 Type
        $objWorksheet->setCellValue('E25', ($this->_aPropertyData['PROP_ESTIMATE']['LOAN2_RATE']/100)); //Interest Rate
        $objWorksheet->getStyle('E25')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
        $objWorksheet->setCellValue('E26', $this->_aPropertyData['PROP_ESTIMATE']['LOAN2_TERM']); //Amortization Term
        $objWorksheet->setCellValue('E27', '=IF(E24="Amortizing",PMT(E25/12,E26*12,E23,0,0),-E23*E25/12)'); //Monthly Payment
        $objWorksheet->getStyle('E27')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);

        

        // Right side
        $objWorksheet->setCellValue('H5', '=(B22/12)+E21+E27'); //Monthly Cash Flow
        $objWorksheet->getStyle('H5')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('H6', '=(B22)+(E21*12)+(E27*12)'); //Annual Cash Flow
        $objWorksheet->getStyle('H6')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('H7', '=H6/E15'); //Cash on Cash Return
        // Cash
        $objWorksheet->setCellValue('H10', '=-E15'); //Investment
        $objWorksheet->setCellValue('H11', '=H6'); //Year 1
        $objWorksheet->setCellValue('H12', '=H6'); //Year 2
        $objWorksheet->setCellValue('H13', '=H6'); //Year 3
        $objWorksheet->setCellValue('H14', '=H6'); //Year 4
        
        // Loan1
        $objWorksheet->setCellValue('I10', '=E17'); //Investment
        $objWorksheet->setCellValue('I11', '=IF(E18="Amortizing",PPMT(E19,1,E20,E17),0)'); //Year 1
        $objWorksheet->setCellValue('I12', '=IF(E18="Amortizing",PPMT(E19,2,E20,E17),0)'); //Year 2
        $objWorksheet->setCellValue('I13', '=IF(E18="Amortizing",PPMT(E19,3,E20,E17),0)'); //Year 3
        $objWorksheet->setCellValue('I14', '=IF(E18="Amortizing",PPMT(E19,4,E20,E17),0)'); //Year 4
        $objWorksheet->setCellValue('I15', '=IF(E18="Amortizing",PPMT(E19,5,E20,E17),0)'); //Year 5
        $objWorksheet->setCellValue('I16', '=I10+I11+I12+I13+I14+I15'); //Total
        // Loan2
        $objWorksheet->setCellValue('J10', '=E23'); //Investment
        $objWorksheet->setCellValue('J11', '=IF(E24="Amortizing",PPMT(E25,1,E26,E23),0)'); //Year 1
        $objWorksheet->setCellValue('J12', '=IF(E24="Amortizing",PPMT(E25,2,E26,E23),0)'); //Year 2
        $objWorksheet->setCellValue('J13', '=IF(E24="Amortizing",PPMT(E25,3,E26,E23),0)'); //Year 3
        $objWorksheet->setCellValue('J14', '=IF(E24="Amortizing",PPMT(E25,4,E26,E23),0)'); //Year 4
        $objWorksheet->setCellValue('J15', '=IF(E24="Amortizing",PPMT(E25,5,E26,E23),0)'); //Year 5
        $objWorksheet->setCellValue('J16', '=J10+J11+J12+J13+J14+J15'); //Total

        $objWorksheet->setCellValue('H15', '=H6+H18+H19-I16-J16'); //Year 5

        // Set loans' cells format
        $objWorksheet->getStyle('H10:J16')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);

        // Totals
        $objWorksheet->setCellValue('H18', '=FV(E8,5,0,0-E11)'); //Sale Price
        $objWorksheet->getStyle('H18')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('H19', '=0-H18*E9'); //Sale Costs
        $objWorksheet->getStyle('H19')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_USD);
        $objWorksheet->setCellValue('H20', '=IRR(H10:H15,0.1)'); //5 Year IRR
        $objWorksheet->getStyle('H20')->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_PERCENTAGE_00);
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
        header('Content-Disposition: attachment;filename="single_property2.xls"');
        header('Cache-Control: max-age=0');

        $this->_oWriter = PHPExcel_IOFactory::createWriter($this->_oPHPExcel, 'Excel5');
        $this->_oWriter->setPreCalculateFormulas(true);
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
        header('Content-Disposition: attachment;filename="single_property2.xlsx"');
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

    private function nvl($expr1, $expr2)
    {
        return (empty($expr1) ? $expr2 : $expr1);
    }
}
