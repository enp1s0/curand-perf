NVCC=nvcc
NVCCFLAGS=-std=c++14
NVCCFLAGS+=-gencode arch=compute_80,code=sm_80
NVCCFLAGS+=

TARGET=curand-perf.test

$(TARGET):src/main.cu
	$(NVCC) $< -o $@ $(NVCCFLAGS)
  
clean:
	rm -f $(TARGET)
