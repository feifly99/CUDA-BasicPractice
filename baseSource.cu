#include "baseHeader.h"

OUT_HOST_PTR PDATA_SET makeDataSet(
	IN myCudaDataFlag inputDataFlag,
	IN DATA_GENERATE_TYPE dataGenerateType,
	IN SIZE_T (*dimensions)[MAX_DIMENSION_SIZE],
	IN_OPT PVOID existData
)
{
	if ((*dimensions) == NULL)
	{
		printf("���Ϸ���ά�����룬�Ѳ���.\n");
		exit(0xA000);
	}
	PDATA_SET ret = (PDATA_SET)malloc(sizeof(DATA_SET));
	ret->dataFlag = inputDataFlag;
	if (ret->dataFlag == CUDA_DATA_FLAG_$_VECTOR_$)
	{
		if ((*dimensions)[1] != 0 || (*dimensions)[2] != 0)
		{
			printf("����ά�����������Ϳ��ܲ������Ѳ���.\n");
			free(ret);
			ret = NULL;
			exit(0xFA00);
		}

		ret->dataType.V.size = (*dimensions)[0];

		ret->dataType.V.vector = (float*)malloc((*dimensions)[0] * sizeof(float));
		RtlZeroMemory(ret->dataType.V.vector, (*dimensions)[0]);

		ret->dataType.V.objectReference = 1;		

		if (dataGenerateType == GENERATE_RANDOM)
		{
			fors(
				ret->dataType.V.size,
				ret->dataType.V.vector[j] = (float)(rand() % 20 + 1);
			);
		}
		else if (dataGenerateType == GENERATE_ALL_ZERO)
		{
			fors(
				ret->dataType.V.size,
				ret->dataType.V.vector[j] = 0.0;
			);
		}
		else if (dataGenerateType == GENERATE_ALL_ONE)
		{
			fors(
				ret->dataType.V.size,
				ret->dataType.V.vector[j] = 1.0;
			);
		}
		else if (dataGenerateType == GENERATE_TEST)
		{
			fors(
				ret->dataType.V.size,
				ret->dataType.V.vector[j] = (float)j;
			);
		}
		else if (dataGenerateType == GENERATE_EXISTING)
		{
			if (existData == NULL)
			{
				printf("ѡ�����Ѵ������ݽ��и��Ƶ�������ָ��Ϊ�գ��Ѳ���.\n");
				free(ret->dataType.V.vector);
				ret->dataType.V.vector = NULL;
				free(ret);
				ret = NULL;
				exit(0xFAC0);
			}
			else
			{
				fors(
					ret->dataType.V.size,
					ret->dataType.V.vector[j] = ((float*)existData)[j];
				);
			}
		}
		else
		{
			printf("�������Ͳ������Ѳ���.\n");
			free(ret->dataType.V.vector);
			ret->dataType.V.vector = NULL;
			free(ret);
			ret = NULL;
			exit(0xFAF0);
		}
	}
	else if (ret->dataFlag == CUDA_DATA_FLAG_$_MATRIX_$)
	{
		if ((*dimensions)[2] != 0)
		{
			printf("����ά�����������Ͳ������Ѳ���.\n");
			free(ret);
			ret = NULL;
			exit(0xFA00);
		}

		ret->dataType.M.rowSize = (*dimensions)[0];
		ret->dataType.M.colSize = (*dimensions)[1];

		ret->dataType.M.matrix = (float**)malloc((*dimensions)[0] * sizeof(float*));

		fors(
			(*dimensions)[0],
			ret->dataType.M.matrix[j] = (float*)malloc((*dimensions)[1] * sizeof(float));
		);
		forss(
			(*dimensions)[0], (*dimensions)[1],
			ret->dataType.M.matrix[j][i] = 0.0;,
		);

		ret->dataType.M.objectReference = 1;

		if (dataGenerateType == GENERATE_RANDOM)
		{
			forss(
				(*dimensions)[0], (*dimensions)[1],
				ret->dataType.M.matrix[j][i] = (float)(rand() % 20 + 1);,
			);
		}
		else if (dataGenerateType == GENERATE_ALL_ZERO)
		{
			forss(
				(*dimensions)[0], (*dimensions)[1],
				ret->dataType.M.matrix[j][i] = 0.0;,
			);
		}
		else if (dataGenerateType == GENERATE_ALL_ONE)
		{
			forss(
				(*dimensions)[0], (*dimensions)[1],
				ret->dataType.M.matrix[j][i] = 1.0;,
			);
		}
		else if (dataGenerateType == GENERATE_TEST)
		{
			forss(
				(*dimensions)[0], (*dimensions)[1],
				ret->dataType.M.matrix[j][i] = (float)(j * i);,
			);
		}
		else if (dataGenerateType == GENERATE_EXISTING)
		{
			if (existData == NULL)
			{
				printf("ѡ�����Ѵ������ݽ��и��Ƶ�������ָ��Ϊ�գ��Ѳ���.\n");
				
				fors(
					(*dimensions)[0],
					free(ret->dataType.M.matrix[j]);
					ret->dataType.M.matrix[j] = NULL;
				);
				free(ret->dataType.M.matrix);
				ret->dataType.M.matrix = NULL;
				exit(0xFAC0);
			}
			else
			{
				forss(
					(*dimensions)[0], (*dimensions)[1],
					ret->dataType.M.matrix[j][i] = ((float**)existData)[j][i];,
				);
			}
		}
		else
		{
			printf("�������Ͳ������Ѳ���.\n");
			fors(
				(*dimensions)[0],
				free(ret->dataType.M.matrix[j]);
				ret->dataType.M.matrix[j] = NULL;
			);
			free(ret->dataType.M.matrix);
			ret->dataType.M.matrix = NULL;
			exit(0xFAF0);
		}
	}
	else
	{
		printf("�������Ͳ������Ѳ���.\n");
		free(ret);
		ret = NULL;
		exit(0xC000);
	}
	return ret;
}

void checkDataSet(
	IN PDATA_SET dataSet
)
{
	if (dataSet->dataFlag == 1)
	{
		//vector
		if (!dataSet->dataType.V.objectReference)
		{
			printf("�������ü���Ϊ�㣬����Ϊ�գ��Ѳ���.\n");
		}
		printf("���ݼ�: ����\n");
		printf("��������: %zu\n", dataSet->dataType.V.size);
		printf("��ǰ���ü���: %zu\n", dataSet->dataType.V.objectReference);
		printf("������ֵ: \n");
		fors(
			dataSet->dataType.V.size,
			printf("%.3f\t", dataSet->dataType.V.vector[j]);
		);
		QAQ;
		return;
	}
	else if (dataSet->dataFlag == 2)
	{
		//matrix
		if (!dataSet->dataType.M.objectReference)
		{
			printf("�������ü���Ϊ�㣬����Ϊ�գ��Ѳ���.\n");
		}
		printf("���ݼ�: ����\n");
		printf("��������: %zu\n", dataSet->dataType.M.rowSize);
		printf("��������: %zu\n", dataSet->dataType.M.colSize);
		printf("��ǰ���ü���: %zu\n", dataSet->dataType.M.objectReference);
		printf("������ֵ: \n");
		forss(
			dataSet->dataType.M.rowSize, dataSet->dataType.M.colSize,
			printf("%.3f\t", dataSet->dataType.M.matrix[j][i]);,
			QAQ;
		);
	}
	else
	{
		printf("�Ƿ��������ͣ��Ѳ���.\n");
	}
	return;
}

void makeCudaFriendlyData(
	IN PDATA_SET hostDataSet,
	OUT_HOST_PTR float** deviceDataSet
)
{
	if (hostDataSet->dataFlag == CUDA_DATA_FLAG_$_VECTOR_$)
	{
		//vector
		if (!hostDataSet->dataType.V.objectReference)
		{
			printf("�������ü���Ϊ�㣬����Ϊ�գ��Ѳ���.\n");
		}
		*deviceDataSet = (float*)malloc(hostDataSet->dataType.V.size * sizeof(float));
		memcpy(*deviceDataSet, hostDataSet->dataType.V.vector, hostDataSet->dataType.V.size * sizeof(float));
		return;
	}
	else if (hostDataSet->dataFlag == CUDA_DATA_FLAG_$_MATRIX_$)
	{
		//matrix
		if (!hostDataSet->dataType.M.objectReference)
		{
			printf("�������ü���Ϊ�㣬����Ϊ�գ��Ѳ���.\n");
		}
		*deviceDataSet = (float*)malloc(hostDataSet->dataType.M.rowSize * hostDataSet->dataType.M.colSize * sizeof(float));
		for (size_t j = 0; j < hostDataSet->dataType.M.rowSize; j++)
		{
			for (size_t i = 0; i < hostDataSet->dataType.M.colSize; i++)
			{
				(*deviceDataSet)[i + j * hostDataSet->dataType.M.colSize] = hostDataSet->dataType.M.matrix[j][i];
			}
		}
	}
	else
	{
		printf("�Ƿ��������ͣ��Ѳ���.\n");
	}
	return;
}

void safetyCheck(
	IN PDATA_SET dataSet1,
	IN PDATA_SET dataSet2,
	IN myCudaDataFlag dataFlag,
	IN myCudaCalculateFlag calculateFlag
)
{
	if (dataSet1->dataFlag != dataFlag || dataSet2->dataFlag != dataFlag)
	{
		printf("�������ݼ������ͺ͵��õ����ݼ����Ͳ�ͬ���Ѳ���.\n");
		exit(0xECC0);
	}
	if (dataFlag == CUDA_DATA_FLAG_$_VECTOR_$)
	{
		if (calculateFlag == CUDA_CAU_TYPE_$_ADD_$)
		{
			if (dataSet1->dataType.V.size != dataSet2->dataType.V.size)
			{
				printf("���������ĳߴ粻ͬ���Ѳ���.\n");
				exit(0xDCC0);
			}
		}
		else if (calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
		{
			if (dataSet1->dataType.V.size != dataSet2->dataType.V.size)
			{
				printf("���������ĳߴ粻ͬ���Ѳ���.\n");
				exit(0xDCC0);
			}
		}
		else
		{
			printf("���õļ������Ͳ���֧�֣��Ѳ���.\n");
			exit(0xDCC0);
		}
	}
	else if (dataFlag == CUDA_DATA_FLAG_$_MATRIX_$)
	{
		if (calculateFlag == CUDA_CAU_TYPE_$_ADD_$)
		{
			if
			(
				(dataSet1->dataType.M.rowSize != dataSet2->dataType.M.rowSize)
				||
				(dataSet2->dataType.M.colSize != dataSet2->dataType.M.colSize)
			)
			{
				printf("��ͼִ�о���ӷ�������������������в�����ͬ���Ѳ���.\n");
				exit(0xDCC8);
			}
		}
		else if (calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
		{
			if (dataSet1->dataType.M.colSize != dataSet2->dataType.M.rowSize)
			{
				printf("��ͼִ�о���˷������ǵ�һ��������к͵ڶ���������в�����ͬ���Ѳ���.\n");
				exit(0xDCC8);
			}
		}
		else
		{
			printf("���õļ������Ͳ���֧�֣��Ѳ���.\n");
			exit(0xDCC0);
		}
	}
	else
	{
		printf("������������ʹ����Ѳ���.\n");
		exit(0xACC0);
	}
}

void cudaExFreeMem(
	IN_OUT PVOID* _GPU_mem
)
{
	cudaFree(*_GPU_mem);
	*_GPU_mem = NULL;
	return;
}

void ExFreeMem(
	IN_OUT PVOID* mem
)
{
	free(*mem);
	*mem = NULL;
	return;
}

static void ExFreeDataSet_$_VECTOR_$(
	IN_OUT PDATA_SET* dataSet
)
{
	if ((*dataSet)->dataFlag != CUDA_DATA_FLAG_$_VECTOR_$)
	{
		printf("�������Ͳ������Ѳ���.\n");
		exit(0xCFF0);
	}
	ExFreeMem((PVOID*)&((*dataSet)->dataType.V.vector));
	return;
}

static void ExFreeDataSet_$_MATRIX_$(
	IN_OUT PDATA_SET* dataSet
)
{
	if ((*dataSet)->dataFlag != CUDA_DATA_FLAG_$_MATRIX_$)
	{
		printf("�������Ͳ������Ѳ���.\n");
		exit(0xCFF0);
	}
	fors(
		(*dataSet)->dataType.M.rowSize,
		ExFreeMem((PVOID*)&((*dataSet)->dataType.M.matrix[j]));
	);
	ExFreeMem((PVOID*)&((*dataSet)->dataType.M.matrix));
	return;
}

void ExFreeDataSet(
	IN_OUT PDATA_SET* dataSet
)
{
	switch ((*dataSet)->dataFlag)
	{
	case CUDA_DATA_FLAG_$_VECTOR_$:
		ExFreeDataSet_$_VECTOR_$(dataSet);
		break;
	case CUDA_DATA_FLAG_$_MATRIX_$:
		ExFreeDataSet_$_MATRIX_$(dataSet);
		break;
	default:
		printf("�Ƿ��������ͣ��Ѳ���.\n");
		break;
	}
	return;
}

void callCuda(
	IN PDATA_SET dataSet1,
	IN PDATA_SET dataSet2,
	IN myCudaDataFlag dataFlag,
	IN myCudaCalculateFlag calculateFlag,
	OUT_HOST_PTR float** ret
)
{
	safetyCheck(dataSet1, dataSet2, dataFlag, calculateFlag);

	float* _host_linerData1 = NULL;
	float* _host_linerData2 = NULL;

	makeCudaFriendlyData(dataSet1, &_host_linerData1);
	makeCudaFriendlyData(dataSet2, &_host_linerData2);

	float* _device_linerData1 = NULL;
	float* _device_linerData2 = NULL;

	float* _device_result = NULL;
	size_t _public_resultSize = 0x0;

	if (dataFlag == CUDA_DATA_FLAG_$_VECTOR_$ && calculateFlag == CUDA_CAU_TYPE_$_ADD_$)
	{
		_public_resultSize = dataSet1->dataType.V.size;
		cudaMalloc(&_device_result, _public_resultSize * sizeof(float));
	}
	if (dataFlag == CUDA_DATA_FLAG_$_VECTOR_$ && calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
	{
		_public_resultSize = 1;
		cudaMalloc(&_device_result, _public_resultSize * sizeof(float));
	}
	if (dataFlag == CUDA_DATA_FLAG_$_MATRIX_$ && calculateFlag == CUDA_CAU_TYPE_$_ADD_$)
	{
		_public_resultSize = dataSet1->dataType.M.rowSize * dataSet1->dataType.M.colSize;
		cudaMalloc(&_device_result, _public_resultSize * sizeof(float));
	}
	if (dataFlag == CUDA_DATA_FLAG_$_MATRIX_$ && calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
	{
		_public_resultSize = dataSet1->dataType.M.rowSize * dataSet2->dataType.M.colSize;
		printf("_public_resultSize: %zu\n", _public_resultSize);
		cudaMalloc(&_device_result, _public_resultSize * sizeof(float));

		cudaMalloc(&_device_linerData1, dataSet1->dataType.M.rowSize * dataSet1->dataType.M.colSize * sizeof(float));
		cudaMalloc(&_device_linerData2, dataSet2->dataType.M.rowSize * dataSet2->dataType.M.colSize * sizeof(float));

		cudaMemcpy(_device_linerData1, _host_linerData1, dataSet1->dataType.M.rowSize * dataSet1->dataType.M.colSize * sizeof(float), cudaMemcpyHostToDevice);
		cudaMemcpy(_device_linerData2, _host_linerData2, dataSet2->dataType.M.rowSize * dataSet2->dataType.M.colSize * sizeof(float), cudaMemcpyHostToDevice);
		
		dim3 threadEx = { 0 };
		threadEx.x = 32;
		threadEx.y = 32;
		threadEx.z = 1;
		
		dim3 blockEx = { 0 };
		blockEx.x = 32;
		blockEx.y = 32;
		blockEx.z = 1;
		
		size_t data1_row = dataSet1->dataType.M.rowSize;
		size_t data1_col = dataSet1->dataType.M.colSize;
		size_t data2_row = dataSet2->dataType.M.rowSize;
		size_t data2_col = dataSet2->dataType.M.colSize;
		
		myCudaMatrixMultiple << <blockEx, threadEx >> > (_device_linerData1, _device_linerData2, data1_row, data1_col, data2_row, data2_col, _device_result);
	}
	//��������CUDA��ʽ��������Ϊ������ֵ������С��ǰ�ĵ�resultSize��ͬ��
	float* _host_result = NULL;
	_host_result = (float*)malloc(_public_resultSize * sizeof(float));
	if (_host_result != NULL)
	{
		cudaMemcpy(_host_result, _device_result, _public_resultSize * sizeof(float), cudaMemcpyDeviceToHost);
		*ret = _host_result;

		cudaExFreeMem((PVOID*)&_device_result);
		cudaExFreeMem((PVOID*)&_device_linerData2);
		cudaExFreeMem((PVOID*)&_device_linerData1);
		ExFreeMem((PVOID*)&_host_linerData2);
		ExFreeMem((PVOID*)&_host_linerData1);
	}
	else
	{		
		ExFreeMem((PVOID*)&_host_result);

		cudaExFreeMem((PVOID*)&_device_result);
		cudaExFreeMem((PVOID*)&_device_linerData2);
		cudaExFreeMem((PVOID*)&_device_linerData1);
		ExFreeMem((PVOID*)&_host_linerData2);
		ExFreeMem((PVOID*)&_host_linerData1);
		printf("�豸GPU�ڴ�������ָ��Ϊ�գ��Ѳ���.\n");
		*ret = NULL;
		exit(0xFFFF);
	}
	cudaDeviceReset();
	return ;
}