$(document).ready(function() {
	
	/** ****************** 交互部分 ******************************* */
	// 显示充值金额的大写 输入金额错误后的提示信息
	$("#plan_scale").keyup(function() {
		FilterNum($("#plan_scale")[0]);
		var capital = $("#plan_scale").val();
		if (capital) {
			capital = capMoney(capital);
			if (capital == "金额过大") {
				$("#plan_scale").val("");
			}
			$("#requestbala_hz").html(capital);
		} else {
			$("#requestbala_hz").html("");
		}
	});

	$("#plan_scale").blur(function() {
		$(this).keyup();
	});
	/** ****************** 验证部分 ******************************* */
	$("#plan_scale").keyup();
});


/**
 * 格式化输入金额，字符均不能输入，只能输入数字和小数点
 * 
 * @param thisRef
 *            输入值
 * @returns
 */
function FilterNum(thisRef) {
	var desValue = thisRef.value;
	if(desValue=="存入金额1元起") return;
	if (desValue == null) {
		desValue = "";
	}
	desValue = desValue.replace(/[^0123456789.]/g, ""); // 替换空格
	if (desValue.indexOf(".") > 0) {
		desValue = desValue.substring(0, desValue.indexOf(".") + 3);
	}
	if (desValue.indexOf("..") > 0) {
		desValue =desValue.substring(0,desValue.length-1 );
	}
	if (desValue.indexOf(".") == 0) {
		desValue = "0" + desValue;
	}
	if ((desValue.indexOf("0") == 0) && (desValue.indexOf(".") != 1)) {
		desValue = desValue.substring(1, desValue.length);
	}

	thisRef.value = desValue;
	return desValue;
}
function showError(msg) {
	showAlertErrorMsg(msg, '', '');
}
