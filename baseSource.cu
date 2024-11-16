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
		printf("不合法的维数输入，已驳回.\n");
		exit(0xA000);
	}
	PDATA_SET ret = (PDATA_SET)malloc(sizeof(DATA_SET));
	ret->dataFlag = inputDataFlag;
	if (ret->dataFlag == CUDA_DATA_FLAG_$_VECTOR_$)
	{
		if ((*dimensions)[1] != 0 || (*dimensions)[2] != 0)
		{
			printf("输入维数和数据类型可能不符，已驳回.\n");
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
				printf("选择了已存在数据进行复制但是输入指针为空，已驳回.\n");
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
			printf("生成类型不符，已驳回.\n");
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
			printf("输入维数和数据类型不符，已驳回.\n");
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
				printf("选择了已存在数据进行复制但是输入指针为空，已驳回.\n");
				
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
			printf("生成类型不符，已驳回.\n");
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
		printf("数据类型不符，已驳回.\n");
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
			printf("对象引用计数为零，可能为空，已驳回.\n");
		}
		printf("数据集: 向量\n");
		printf("向量长度: %zu\n", dataSet->dataType.V.size);
		printf("当前引用计数: %zu\n", dataSet->dataType.V.objectReference);
		printf("具体数值: \n");
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
			printf("对象引用计数为零，可能为空，已驳回.\n");
		}
		printf("数据集: 矩阵\n");
		printf("矩阵行数: %zu\n", dataSet->dataType.M.rowSize);
		printf("矩阵列数: %zu\n", dataSet->dataType.M.colSize);
		printf("当前引用计数: %zu\n", dataSet->dataType.M.objectReference);
		printf("具体数值: \n");
		forss(
			dataSet->dataType.M.rowSize, dataSet->dataType.M.colSize,
			printf("%.3f\t", dataSet->dataType.M.matrix[j][i]);,
			QAQ;
		);
	}
	else
	{
		printf("非法数据类型，已驳回.\n");
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
			printf("对象引用计数为零，可能为空，已驳回.\n");
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
			printf("对象引用计数为零，可能为空，已驳回.\n");
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
		printf("非法数据类型，已驳回.\n");
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
		printf("输入数据集的类型和调用的数据集类型不同，已驳回.\n");
		exit(0xECC0);
	}
	if (dataFlag == CUDA_DATA_FLAG_$_VECTOR_$)
	{
		if (calculateFlag == CUDA_CAU_TYPE_$_ADD_$)
		{
			if (dataSet1->dataType.V.size != dataSet2->dataType.V.size)
			{
				printf("两个向量的尺寸不同，已驳回.\n");
				exit(0xDCC0);
			}
		}
		else if (calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
		{
			if (dataSet1->dataType.V.size != dataSet2->dataType.V.size)
			{
				printf("两个向量的尺寸不同，已驳回.\n");
				exit(0xDCC0);
			}
		}
		else
		{
			printf("调用的计算类型不被支持，已驳回.\n");
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
				printf("试图执行矩阵加法，但是两个矩阵的行列并不相同，已驳回.\n");
				exit(0xDCC8);
			}
		}
		else if (calculateFlag == CUDA_CAU_TYPE_$_MULTIPLE_$)
		{
			if (dataSet1->dataType.M.colSize != dataSet2->dataType.M.rowSize)
			{
				printf("试图执行矩阵乘法，但是第一个矩阵的列和第二个矩阵的行并不相同，已驳回.\n");
				exit(0xDCC8);
			}
		}
		else
		{
			printf("调用的计算类型不被支持，已驳回.\n");
			exit(0xDCC0);
		}
	}
	else
	{
		printf("输入的数据类型错误，已驳回.\n");
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
		printf("数据类型不符，已驳回.\n");
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
		printf("数据类型不符，已驳回.\n");
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
		printf("非法数据类型，已驳回.\n");
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
	//定义主机CUDA格式向量，作为《返回值》，大小和前文的resultSize相同：
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
		printf("设备GPU内存运算结果指针为空，已驳回.\n");
		*ret = NULL;
		exit(0xFFFF);
	}
	cudaDeviceReset();
	return ;
}