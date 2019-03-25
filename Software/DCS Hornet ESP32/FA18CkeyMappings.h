// FA18C_Keymappings.h

#ifndef _FA18CKEYMAPPINGS_h
#define _FA18CKEYMAPPINGS_h

#define FA18KEYMAPPINGS_MAXKEYS 39
const int16_t  keyMappings[5][FA18KEYMAPPINGS_MAXKEYS] = {  // this is the lookup table for the up front controller keys and other switches
	{ 101,102,103,104,105     //  1   | UFC#1 | UFC#2 | UFC#3 | UFC#4 | UFC#5
	,106,107,108,109,110     //  2    | UFC#6 | UFC#7 | UFC#8 | UFC#9 | UFC_CLR
	,111,112,117,120,123     //  3    | UFC#0 | UFC_ENT | ODU1 | ODU2 | ODU3
	,126,127,125,128,119     //  4    | ODU4 | ODU5 | I/P | EMCON | ADF
	,122,134,135,136,137     //  5    | ADF | A/P | IFF | TACAN | ILS
	,138,139,140,133,141     //  6    | D/L | Beacon | On/OFF | Chan 1 Pull | Chan 2 Pull
	,198,199,850,851,852     //  7    | Chan 1 Pull RGB | Chan 2 Pull RGB | UFC_Brt | UFC_Vol1 | UFC_Vol2
	,853,854                 //  8    | UFC_Chan1 | UFC_Chan2
	,0                       //  End of array marker
	},
	{ 19,20,21,22,23          //  1  
	,24,25,26,27,28          //  2
	,18,29,10,11,12          //  3
	,13,14,15,17,16          //  4
	,16,1,2,3,4              //  5
	,5,6,7,8,9               //  6
	,8,9,32,30,31            //  7
	,33,34                   //  8
	},
	{ 1,1,1,1,1               //  1  
	,1,1,1,1,1               //  2
	,1,1,1,1,1               //  3
	,1,1,1,1,1               //  4
	,-1,1,1,1,1               //  5
	,1,1,1,1,1               //  6
	,1,1,50,51,52            //  7
	,53,54                   //  8
	},
	{ 25,25,25,25,25          //  1  
	,25,25,25,25,25          //  2
	,25,25,25,25,25          //  3
	,25,25,25,25,25          //  4
	,25,25,25,25,25          //  5
	,25,25,25,25,25          //  6
	,25,25,25,25,25          //  7
	,25,25                   //  8
	},
	{ 0,0,0,0,0               //  1   | UFC#1 | UFC#2 | UFC#3 | UFC#4 | UFC#5
	,0,0,0,0,0               //  2    | UFC#6 | UFC#7 | UFC#8 | UFC#9 | UFC_CLR
	,0,0,0,0,0               //  3    | UFC#0 | UFC_ENT | ODU1 | ODU2 | ODU3
	,0,0,0,0,0               //  4    | ODU4 | ODU5 | I/P | EMCON | ADF
	,0,0,0,0,0               //  5    | ADF | A/P | IFF | TACAN | ILS
	,0,0,0,0,0               //  6    | D/L | Beacon | On/OFF | Chan 1 Pull | Chan 2 Pull
	,0,0,0,0,0               //  7    | Chan 1 Pull RGB | Chan 2 Pull RGB | UFC_Brt | UFC_Vol1 | UFC_Vol2
	,0,0                     //  8    | UFC_Chan1 | UFC_Chan2
	}
}; 
#endif

