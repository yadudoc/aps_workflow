type file;

app (file out, file err) mpi_app (file mpi_sh)
{
    bash @mpi_sh stdout=@out stderr=@err;
}

int  itermax     = toInt(arg("niter", "20"));     # number of iterations for mpi_app
int  step        = toInt(arg("step", "5"));       # number of iterations for mpi_app
int  resolution  = toInt(arg("res",  "10000"));   # Resolution of result

// 5 -> 100 iterations stepping by 5
file mandel_img[] <simple_mapper; prefix="output/mandel_", suffix=".jpg">;
file mandel_out[] <simple_mapper; prefix="output/mandel_", suffix=".out">;
file mandel_err[] <simple_mapper; prefix="output/mandel_", suffix=".err">;
file mandel_sh <"./bin/run_mpi_app">;

foreach i in [5:itermax:step]{
    tracef("i = %i \n", i);
    (mandel_out[i], mandel_err[i]) = mpi_app(mandel_sh);
}

