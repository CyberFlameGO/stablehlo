// RUN-DISABLED(#1278): stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3xbf16>, tensor<bf16>)
    %1 = call @expected() : () -> tensor<2x7xbf16>
    %2 = stablehlo.pad %0#0, %0#1, low = [0, -2], high = [0, -2], interior = [0, 4] : (tensor<2x3xbf16>, tensor<bf16>) -> tensor<2x7xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x7xbf16>, tensor<2x7xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xbf16>, tensor<bf16>) {
    %0 = stablehlo.constant dense<[[-1.430510e-04, 5.836480e-04, 9.040830e-04], [-8.163450e-04, -1.152040e-03, 4.291530e-04]]> : tensor<2x3xbf16>
    %1 = stablehlo.constant dense<0.000000e+00> : tensor<bf16>
    return %0, %1 : tensor<2x3xbf16>, tensor<bf16>
  }
  func.func private @expected() -> tensor<2x7xbf16> {
    %0 = stablehlo.constant dense<[[0.000000e+00, 0.000000e+00, 0.000000e+00, 5.836480e-04, 0.000000e+00, 0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00, 0.000000e+00, -1.152040e-03, 0.000000e+00, 0.000000e+00, 0.000000e+00]]> : tensor<2x7xbf16>
    return %0 : tensor<2x7xbf16>
  }
}
