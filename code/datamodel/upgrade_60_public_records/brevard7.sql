set define '^'

begin

pr_records_pkg.insert_feature_code( X_FCODE        => 100
                                 , X_DESCRIPTION  => 'Exterior'
                                 , X_PARENT_FCODE => null);

pr_records_pkg.insert_feature_code( X_FCODE        => 101
                                 , X_DESCRIPTION  => 'Frame'
                                 , X_PARENT_FCODE => null);

pr_records_pkg.insert_feature_code( X_FCODE        => 102
                                 , X_DESCRIPTION  => 'Roof Material'
                                 , X_PARENT_FCODE => null);

pr_records_pkg.insert_feature_code( X_FCODE        => 103
                                 , X_DESCRIPTION  => 'Roof Type'
                                 , X_PARENT_FCODE => null);

pr_records_pkg.insert_feature_code( X_FCODE        => 104
                                 , X_DESCRIPTION  => 'Feature'
                                 , X_PARENT_FCODE => null);




pr_records_pkg.insert_feature_code( X_FCODE        => 01
                                 , X_DESCRIPTION  => 'Asph/Asb Single Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 02
                                 , X_DESCRIPTION  => 'Sheet Metal Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 03
                                 , X_DESCRIPTION  => 'Stucco Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 04
                                 , X_DESCRIPTION  => 'Brd/Lap Siding Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 05
                                 , X_DESCRIPTION  => 'Painted Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 06
                                 , X_DESCRIPTION  => 'Brick Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 07
                                 , X_DESCRIPTION  => 'Enamel Steel Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 08
                                 , X_DESCRIPTION  => 'Thermal Glass Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 09
                                 , X_DESCRIPTION  => 'Plywd/T111 Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 10
                                 , X_DESCRIPTION  => 'Cedar B & B Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 11
                                 , X_DESCRIPTION  => 'Styrfm Stucco Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 12
                                 , X_DESCRIPTION  => 'Hrdybrd Siding Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 13
                                 , X_DESCRIPTION  => 'Vinyl/Aluminum Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 14
                                 , X_DESCRIPTION  => 'Stone Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 15
                                 , X_DESCRIPTION  => 'Wood Shingles Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 16
                                 , X_DESCRIPTION  => 'Log Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 17
                                 , X_DESCRIPTION  => 'Arch Block Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 18
                                 , X_DESCRIPTION  => 'Synthetic Tile Exterior'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 99
                                 , X_DESCRIPTION  => 'No Exterior Cover'
                                 , X_PARENT_FCODE => 100);

pr_records_pkg.insert_feature_code( X_FCODE        => 19
                                 , X_DESCRIPTION  => 'Multiple Exterior Types'
                                 , X_PARENT_FCODE => 100);


pr_records_pkg.insert_feature_code( X_FCODE        => 21
                                 , X_DESCRIPTION  => 'Strucsteel Frame'
                                 , X_PARENT_FCODE => 101);

pr_records_pkg.insert_feature_code( X_FCODE        => 22
                                 , X_DESCRIPTION  => 'Reinforced Concrete Frame'
                                 , X_PARENT_FCODE => 101);

pr_records_pkg.insert_feature_code( X_FCODE        => 23
                                 , X_DESCRIPTION  => 'Masonry Concete Frame'
                                 , X_PARENT_FCODE => 101);

pr_records_pkg.insert_feature_code( X_FCODE        => 24
                                 , X_DESCRIPTION  => 'Wood Frame'
                                 , X_PARENT_FCODE => 101);

pr_records_pkg.insert_feature_code( X_FCODE        => 25
                                 , X_DESCRIPTION  => 'Metalframe'
                                 , X_PARENT_FCODE => 101);

pr_records_pkg.insert_feature_code( X_FCODE        => 26
                                 , X_DESCRIPTION  => 'Multiple Frame Types'
                                 , X_PARENT_FCODE => 101);



pr_records_pkg.insert_feature_code( X_FCODE        => 31
                                 , X_DESCRIPTION  => 'Sheet Metal Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 32
                                 , X_DESCRIPTION  => 'Roll Composition Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 33
                                 , X_DESCRIPTION  => 'Bu-Tg/Mmbrn Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 34
                                 , X_DESCRIPTION  => 'Asph/Asb Shngl Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 36
                                 , X_DESCRIPTION  => 'Cem/Cly/Mtl Tile Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 39
                                 , X_DESCRIPTION  => 'Slate Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 40
                                 , X_DESCRIPTION  => 'Metal Leaf Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 41
                                 , X_DESCRIPTION  => 'Enamel Metal Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 42
                                 , X_DESCRIPTION  => 'Wood Shingles Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 43
                                 , X_DESCRIPTION  => 'Syn/Mtl Tile Roof'
                                 , X_PARENT_FCODE => 102);

pr_records_pkg.insert_feature_code( X_FCODE        => 44
                                 , X_DESCRIPTION  => 'Multiple Roof Material'
                                 , X_PARENT_FCODE => 102);



pr_records_pkg.insert_feature_code( X_FCODE        => 51
                                 , X_DESCRIPTION  => 'Flat/Shed Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 52
                                 , X_DESCRIPTION  => 'Hip/Gable Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 54
                                 , X_DESCRIPTION  => 'Irregular Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 55
                                 , X_DESCRIPTION  => 'Gmbrl/Mnsrd/Mntr Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 58
                                 , X_DESCRIPTION  => 'Pre-Strs Concrete Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 59
                                 , X_DESCRIPTION  => 'Wood Truss Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 60
                                 , X_DESCRIPTION  => 'Bar Joist Rigid Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 63
                                 , X_DESCRIPTION  => 'Steel Truss Rigid Roof'
                                 , X_PARENT_FCODE => 103);

pr_records_pkg.insert_feature_code( X_FCODE        => 66
                                 , X_DESCRIPTION  => 'Multiple Roof Types'
                                 , X_PARENT_FCODE => 103);


pr_records_pkg.insert_feature_code( X_FCODE        => 70
                                 , X_DESCRIPTION  => 'Garage'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 71
                                 , X_DESCRIPTION  => 'Car Port'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 72
                                 , X_DESCRIPTION  => 'Screen Room/Porch'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 73
                                 , X_DESCRIPTION  => 'Utility Room'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 74
                                 , X_DESCRIPTION  => 'Enclosed Porch'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 75
                                 , X_DESCRIPTION  => 'Basement'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 76
                                 , X_DESCRIPTION  => 'Attic'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 77
                                 , X_DESCRIPTION  => 'Pool'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 78
                                 , X_DESCRIPTION  => 'Fireplace'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 79
                                 , X_DESCRIPTION  => 'Fence'
                                 , X_PARENT_FCODE => 104);


pr_records_pkg.insert_feature_code( X_FCODE        => 80
                                 , X_DESCRIPTION  => 'Lawn Irrigation System'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 81
                                 , X_DESCRIPTION  => 'Boat Dock'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 82
                                 , X_DESCRIPTION  => 'Sea Wall'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 83
                                 , X_DESCRIPTION  => 'RV Carport'
                                 , X_PARENT_FCODE => 104);

pr_records_pkg.insert_feature_code( X_FCODE        => 84
                                 , X_DESCRIPTION  => 'RV Garage'
                                 , X_PARENT_FCODE => 104);
end;
/
