#ifndef __BASE_C_HEADER_FILE__
#define __BASE_C_HEADER_FILE__

#include "CUDA_CAU_HEARER.h"

#pragma warning(disable:6387)
#pragma warning(disable:6011)

#ifndef IN
#define IN
#endif

#ifndef OUT
#define OUT
#endif

#ifndef IN_OUT
#define IN_OUT
#endif

#ifndef IN_OPT
#define IN_OPT
#endif

#ifndef OUT_HOST_PTR
#define OUT_HOST_PTR
#endif

#ifndef OUT_DEVICE_PTR
#define OUT_DEVICE_PTR
#endif

#define MAX_DIMENSION_SIZE 3

#define fors(times, sentence) \
do\
{\
	for(size_t j = 0; j < (times); j++)\
	{\
		sentence\
	}\
}while(0)

#define forss(times1, times2, sentenceInner, sentenceOuter) \
do\
{\
	for(size_t j = 0; j < (times1); j++)\
	{\
		for(size_t i = 0; i < (times2); i++)\
		{\
			sentenceInner\
		}\
		sentenceOuter\
	}\
}while(0)

#define QAQ printf("\n")

#define ckFloatValueOnly(sen) printf("%.3f\n", (float)(sen))
#define ckFloatValueWithExplain(sen) printf("%s -> %.3f\n", (const char*)#sen, (float)(sen))

#define ckSizeTValueOnly(sen) printf("%zu\n", (SIZE_T)(sen))
#define ckSizeTValueWithExplain(sen) printf("%s -> %zu\n", (const char*)#sen, (SIZE_T)(sen))

typedef enum _DATA_GENERATE_TYPE
{
	GENERATE_RANDOM = 1,
	GENERATE_ALL_ZERO = 2,
	GENERATE_ALL_ONE = 3,
	GENERATE_TEST = 4,
	GENERATE_EXISTING = 5
}DATA_GENERATE_TYPE;

OUT_HOST_PTR PDATA_SET makeDataSet(
	IN myCudaDataFlag inputDataFlag,
	IN DATA_GENERATE_TYPE dataGenerateType,
	IN SIZE_T (*dimensions)[MAX_DIMENSION_SIZE],
	IN_OPT PVOID existData
);

void checkDataSet(
	IN PDATA_SET dataSet
);

void makeCudaFriendlyData(
	IN PDATA_SET hostDataSet,
	OUT_HOST_PTR float** deviceDataSet
);

void safetyCheck(
	IN PDATA_SET dataSet1,
	IN PDATA_SET dataSet2,
	IN myCudaDataFlag dataFlag,
	IN myCudaCalculateFlag calculateFlag
);

void cudaExFreeMem(
	IN_OUT PVOID* _GPU_mem
);

void ExFreeMem(
	IN_OUT PVOID* mem
);

void ExFreeDataSet(
	IN_OUT PDATA_SET* dataSet
);

void callCuda(
	IN PDATA_SET data1,
	IN PDATA_SET data2,
	IN myCudaDataFlag dataFlag,
	IN myCudaCalculateFlag calculateFlag,
	OUT_HOST_PTR float** result
);

#endif