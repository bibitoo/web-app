/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: ZH (Chinese, 中文 (Zhōngwén), 汉语, 漢語)
 */
(function ($) {
	$.extend($.validator.messages, {
		required: "必选字段",
		remote: "请修正该字段",
		email: "请输入正确格式的电子邮件",
		url: "请输入合法的网址",
		date: "请输入合法的日期",
		dateISO: "请输入合法的日期 (ISO).",
		number: "请输入合法的数字",
		digits: "只能输入整数",
		creditcard: "请输入合法的信用卡号",
		equalTo: "请再次输入相同的值",
		accept: "请输入拥有合法后缀名的字符串",
		maxlength: $.validator.format("请输入一个长度最多是 {0} 的字符串"),
		minlength: $.validator.format("请输入一个长度最少是 {0} 的字符串"),
		rangelength: $.validator.format("请输入一个长度介于 {0} 和 {1} 之间的字符串"),
		range: $.validator.format("请输入一个介于 {0} 和 {1} 之间的值"),
		max: $.validator.format("请输入一个最大为 {0} 的值"),
		min: $.validator.format("请输入一个最小为 {0} 的值")
	});
	$.extend($.timeago.settings, {
		refreshMillis: 60000,
	      allowFuture: false,
	      strings: {
			prefixAgo: null,
	  		prefixFromNow: "从现在开始",
	  		suffixAgo: "前",
	  		suffixFromNow: null,
	  		seconds: "不到 1 分钟",
	  		minute: "大约 1 分钟",
	  		minutes: "%d 分钟",
	  		hour: "大约 1 小时",
	  		hours: "大约 %d 小时",
	  		day: "1 天",
	  		days: "%d 天",
	  		month: "大约 1 个月",
	  		months: "%d 个月",
	  		year: "大约 1 年",
	  		years: "%d 年",
	  		numbers: [],
	  		wordSeparator: ""
	      }
	});
}(jQuery));