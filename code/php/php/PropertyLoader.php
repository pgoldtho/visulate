<?php
// PHPExcel libraries
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php';
require_once dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel/IOFactory.php';

/**
 * Load property data from Excel-file.
 *
 * Property's data must be in following format:
 * (
 *      'Address1',
 *      'Address2',
 *      'City',
 *      'State',
 *      'Zip Code',
 *      'Year Built',
 *      'Building Size',
 *      'Units',
 *      'Bedrooms',
 *      'Bathrooms'
 * )
 */
class PropertyLoader {
    /**
     * @var null | PHPExcel
     */
    private $_oPHPExcel        = NULL;

    /**
     * @var null | PHPExcel_Reader_IReader
     */
    private $_oReader          = NULL;

    /**
     * @var array
     */
    private $_aPropertyData    = array();

    /**
     * @var array
     */
    private $_aMissingPropertyAttributes = array();

    // ------------------------------------------------------------------------
    /**
     * Load Excel document.
     *
     * @param  string  $inputFileName
     */
    public function __construct($inputFileName)
    {
        $inputFileType    = PHPExcel_IOFactory::identify($inputFileName);
        $this->_oReader   = PHPExcel_IOFactory::createReader($inputFileType);
        $this->_oPHPExcel = $this->_oReader->load($inputFileName);
        $this->_readPropertyData();
        $this->_mapPropertyData();
    }

    // ------------------------------------------------------------------------
    /**
     * Get loaded property data.
     *
     * @throws Exception
     * @return array
     */
    public function getPropertyData()
    {
        if (count( $this->_aMissingPropertyAttributes)) {
            throw new Exception(
                "Problem in spreadsheet.\nNot found required headers: "
                .implode(', ',$this->_aMissingPropertyAttributes) . '.'
                ."\nPlease check it and try uploading again."
            );
        }

        return $this->_aPropertyData;
    }

    // ------------------------------------------------------------------------
    /**
     * Remap loaded property data.
     */
    private function _mapPropertyData()
    {
        $spreadsheetHeaders = array_shift($this->_aPropertyData);
        $spreadsheetHeaders = array_map('strtoupper', $spreadsheetHeaders);

        //map property data headers
        foreach ($this->_defaultRowHeadersMap() as $key => $header)
        {
            $is_common_key = FALSE;
            foreach ($spreadsheetHeaders as $k => $h)
            {
                if ($header != $h) {
                    continue;
                }
                $spreadsheetHeaders[$k] = $key;
                $is_common_key = TRUE;
            }

            if ( ! $is_common_key) {
                $this->_aMissingPropertyAttributes[] = $header;
            }
        }

        //map property data
        foreach ($this->_aPropertyData as $i => $row)
        {
            $this->_aPropertyData[$i] = array_combine($spreadsheetHeaders, $row);
        }
    }

    // ------------------------------------------------------------------------
    /**
     * Load property data.
     */
    private function _readPropertyData()
    {
        $this->_aPropertyData = array();

        // loop all rows with data
        foreach ($this->_oPHPExcel->getActiveSheet()->getRowIterator() as $row)
        {
            // loop all cells, even if it is not set
            $values = array();
            foreach ($row->getCellIterator() as $cell)
            {
                $values[] = trim($cell->getCalculatedValue());
            }

            // build the data row
            $this->_aPropertyData[] = $values;
        }
    }

    // ------------------------------------------------------------------------
    /**
     * Required property attributes.
     *
     * @return  array
     */
    private function _defaultRowHeadersMap()
    {
        return array(
            'ADDRESS1'      => 'ADDRESS1',
            'ADDRESS2'      => 'ADDRESS2',
            'CITY'          => 'CITY',
            'STATE'         => 'STATE',
            'ZIPCODE'       => 'ZIP CODE',
            'YEAR_BUILT'    => 'YEAR BUILT',
            'BUILDING_SIZE' => 'BUILDING SIZE',
            'UNITS'         => 'UNITS',
            'BEDROOMS'      => 'BEDROOMS',
            'BATHROOMS'     => 'BATHROOMS'
        );
    }
}
?>