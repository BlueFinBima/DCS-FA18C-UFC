// FA18C_Keymappings.h

#ifndef _FA18CKEYMAPPINGS_h
#define _FA18CKEYMAPPINGS_h

#define FA18KEYMAPPINGS_MAXKEYS 45
const int16_t  keyMappings[FA18KEYMAPPINGS_MAXKEYS] =   // this is the lookup table for the up front controller keys and other switches
	{ 101,102,103,104,105     //  1   | UFC#1 | UFC#2 | UFC#3 | UFC#4 | UFC#5
	,106,107,108,109,110     //  2    | UFC#6 | UFC#7 | UFC#8 | UFC#9 | UFC_CLR
	,111,112,117,120,123     //  3    | UFC#0 | UFC_ENT | ODU1 | ODU2 | ODU3
	,126,127,125,128,119     //  4    | ODU4 | ODU5 | I/P | EMCON | ADF
	,122,134,135,136,137     //  5    | ADF | A/P | IFF | TACAN | ILS
	,138,139,140,133,141     //  6    | D/L | Beacon | On/OFF | Chan 1 Pull | Chan 2 Pull
	,198,199,850,851,852     //  7    | Chan 1 Pull RGB | Chan 2 Pull RGB | UFC_Brt | UFC_Vol1 | UFC_Vol2
	,853,854                 //  8    | UFC_Chan1 | UFC_Chan2
	,233,204,205,220,221	 //  9    | LDG Lever  | | | | |
	,236,237				 //  10   | | Launch Bar
	,0                       //  End of array marker
	}; 
#define AIRCRAFTNUMBER 2
const int16_t  keyMappingResults[AIRCRAFTNUMBER][4][FA18KEYMAPPINGS_MAXKEYS] = {  // this is the lookup table for the up front controller keys and other switches
	{
		// F/A-18C
		{ 19,20,21,22,23         //  1  
		,24,25,26,27,28          //  2
		,18,29,10,11,12          //  3
		,13,14,15,17,16          //  4
		,16,1,2,3,4              //  5
		,5,6,7,8,9               //  6
		,8,9,32,30,31            //  7
		,33,34                   //  8
		,1,0,0,0,0               //  9
		,0,20                    //  10
		},
		{ 1,1,1,1,1              //  1  
		,1,1,1,1,1               //  2
		,1,1,1,1,1               //  3
		,1,1,1,1,1               //  4
		,-1,1,1,1,1              //  5
		,1,1,1,1,1               //  6
		,1,1,50,51,52            //  7
		,53,54                   //  8
		,1,0,0,0,0               //  9
		,0,1                     //  10
		},
		{ 25,25,25,25,25         //  1  
		,25,25,25,25,25          //  2
		,25,25,25,25,25          //  3
		,25,25,25,25,25          //  4
		,25,25,25,25,25          //  5
		,25,25,25,25,25          //  6
		,25,25,25,25,25          //  7
		,25,25                   //  8
		,5,0,0,0,0               //  9
		,0,3                     //  10
		},
		{ 0,0,0,0,0              //  1    | UFC#1 | UFC#2 | UFC#3 | UFC#4 | UFC#5
		,0,0,0,0,0               //  2    | UFC#6 | UFC#7 | UFC#8 | UFC#9 | UFC_CLR
		,0,0,0,0,0               //  3    | UFC#0 | UFC_ENT | ODU1 | ODU2 | ODU3
		,0,0,0,0,0               //  4    | ODU4 | ODU5 | I/P | EMCON | ADF
		,0,0,0,0,0               //  5    | ADF | A/P | IFF | TACAN | ILS
		,0,0,0,0,0               //  6    | D/L | Beacon | On/OFF | Chan 1 Pull | Chan 2 Pull
		,0,0,0,0,0               //  7    | Chan 1 Pull RGB | Chan 2 Pull RGB | UFC_Brt | UFC_Vol1 | UFC_Vol2
		,0,0                     //  8    | UFC_Chan1 | UFC_Chan2
		,0,9,9,9,9				 //  9    | LDG Lever |
		,9,0  					 //  10   |  |
		}
	},
	{
		// AV-8B
		{ 302,303,304,306,307         //  1  
		,308,310,311,312,305          //  2
		,315,314,250,251,252          //  3
		,253,254,297,325,0            //  4
		,0,1,318,319,0                //  5
		,0,0,317,178,179              //  6
		,0,0,295,298,299              //  7
		,300,301                      //  8
		,461,0,0,0,0               //  9
		,0,20                    //  10
		},
		{ 1,1,1,1,1              //  1  
		,1,1,1,1,1               //  2
		,1,1,1,1,1               //  3
		,1,1,1,1,1               //  4
		,-1,1,1,1,1              //  5
		,1,1,1,1,1               //  6
		,1,1,50,51,52            //  7
		,53,54                   //  8
		,1,0,0,0,0               //  9
		,0,1                     //  10
		},
		{ 23,23,23,23,23         //  1  
		,23,23,23,23,23          //  2
		,23,23,24,24,24          //  3
		,24,24,23,23,23          //  4
		,23,23,23,23,23          //  5
		,23,23,23,23,23          //  6
		,23,23,23,23,23          //  7
		,23,23                   //  8
		,28,0,0,0,0               //  9
		,0,3                     //  10
		},
		{ 0,0,0,0,0              //  1    | UFC#1 | UFC#2 | UFC#3 | UFC#4 | UFC#5
		,0,0,0,0,0               //  2    | UFC#6 | UFC#7 | UFC#8 | UFC#9 | UFC_CLR
		,0,0,0,0,0               //  3    | UFC#0 | UFC_ENT | ODU1 | ODU2 | ODU3
		,0,0,0,0,0               //  4    | ODU4 | ODU5 | I/P | EMCON | 
		,0,0,0,0,0               //  5    |      |      | IFF | TACAN | 
		,0,0,0,0,0               //  6    |     |     | On/OFF | Chan 1 Pull | Chan 2 Pull
		,0,0,0,0,0               //  7    |     |     | UFC_Brt | UFC_Vol1 | UFC_Vol2
		,0,0                     //  8    | UFC_Chan1 | UFC_Chan2
		,0,9,9,9,9				 //  9    | LDG Lever |
		,9,0  					 //  10   |  |
		}
	}
};
#endif

