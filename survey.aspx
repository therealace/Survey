<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="survey.aspx.cs" Inherits="ItemTracking.survey" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Survey</title>
    <script src="jscripts/jquery-1.4.2.min.js" type="text/javascript"></script>
    <meta name="viewport" content="width=300;" />
    <script type="text/javascript">

        function pausecomp(millis) {
            var date = new Date();
            var curDate = null;

            do { curDate = new Date(); }
            while (curDate - date < millis);
        }

        function addPercentageBars() {

            var fullTotal = 0;

            $(".total").each(function () {

                fullTotal = parseInt(fullTotal, 10) + parseInt($(this).text(), 10);

            });


            $(".total").each(function () {

                var percentage;
                var barWidth;

                percentage = (parseInt($(this).text(), 10) / parseInt(fullTotal, 10)) * 100;
                barWidth = 250 * (percentage / 100);
                $(this).after("<br /><div class=percentageBar title=" + percentage.toFixed(2) + "></div> <span class=percentageText>" + percentage.toFixed(2) + "%</span>");
                $(this).siblings("div").css("width", barWidth.toFixed(2) + "px");


            });



        }

        function addNewItem() {

            var item = $(".addItem").attr("title");
            var subitem = $("#newItem").val();
            var user = "";

            if (subitem == "") {
                alert("Please enter an item.");
                return false;
            }

            $.post("surveyadd.aspx?item=" + item + "&subItem=" + subitem);
            $.post("surveysubmit.aspx?item=" + item + "&subItem=" + subitem + "&userID=" + user);

            pausecomp(500);

            $("#fullPage").fadeOut('Slow', function () {
                $("#fullPage").load("survey.aspx #fullPage > *", function () {
                    attachEvents();
                    $("#fullPage").fadeIn('Slow');
                });
            });


        }

        function attachEvents() {

            $(".item[title|='']").removeClass("hidden");

            $(".itemLink").live('click', function () {

                $(".item").addClass("hidden");
                $(".item[href|='" + $(this).attr("href") + "']").removeClass("hidden");
                $(".itemText").addClass("hidden");
                $(".item[title|='']").addClass("hidden");
                $(".addItem").removeClass("hidden");
                $(".addItem").attr("title", $(this).attr("href"));

                return false;

            });

            $(".backLink").live('click', function () {

                $("#fullPage").fadeOut('Slow', function () {

                    $(".item").addClass("hidden");
                    $(".itemText").removeClass("hidden");
                    $(".item[title|='']").removeClass("hidden");
                    $(".addItem").addClass("hidden");
                    $(".addItem").attr("title", "");

                    $("#fullPage").fadeIn('Slow');

                });

                return false;

            });

            $(".backToSurvey").live('click', function () {

                $("#fullPage").fadeOut('Slow', function () {
                    $("#fullPage").load("survey.aspx #fullPage > *", function () {
                        attachEvents();
                        $("#fullPage").fadeIn('Slow');
                    });
                });

                return false;

            });

            $(".submitLink").live('click', function () {


                var item = $(this).attr("href");
                var subitem = $(this).attr("title");
                var user = "";
                $.post("surveysubmit.aspx?item=" + item + "&subItem=" + subitem + "&userID=" + user);

                $(this).parent().html("Added...");

                $("#fullPage").fadeOut('Slow', function () {
                    $("#fullPage").load("survey.aspx #fullPage > *", function () {
                        attachEvents();
                        $("#fullPage").fadeIn('Slow');
                    });
                });

                return false;

            });

            $(".resultsLink").live('click', function () {

                $("#fullPage").fadeOut('Slow', function () {
                    $("#fullPage").load("surveyResults.aspx #fullPage > *", function () {
                        addPercentageBars();
                        $("#fullPage").fadeIn('Slow');
                    });
                });

                return false;

            });

            $(".resultsItem").live('click', function () {

                var item;
                item = $(this).text();
                item = item.replace(/\s/g, "%20");

                //alert("surveyResults.aspx?item=" + item + " #fullPage > *");

                $("#fullPage").fadeOut('Slow', function () {
                    $("#fullPage").load("surveyResults.aspx?item=" + item + " #fullPage > *", function () {
                        addPercentageBars();
                        $("#fullPage").fadeIn('Slow');
                    });
                });

                return false;

            });

            $("#newItemLink").live('click', function () {

                addNewItem();

                return false;

            });

            $("#newItem").live("keydown", function (e) {
                if (e.keyCode == 13) {
                    addNewItem();
                    return false; //prevent default behaviour
                }
                else if (e.keyCode == 190) {
                    return false; //.
                }
                else if (e.keyCode == 222) {
                    return false; //'
                }
                else if (e.keyCode == 191) {
                    return false; ///
                }
                //        else {
                //        alert(e.keyCode);
                //        }
            });

            $(".item").each(function () {

                var hrefLink = $(this).attr("href");
                //count
                var hrefCount = $(".item[href|='" + hrefLink + "']").length;

                if (hrefCount == 1) {

                    $(this).addClass("submitLink");
                    $(this).removeClass("itemLink");

                }
                else if ($(this).attr("title") != "") {
                    $(this).addClass("submitLink");
                    $(this).removeClass("itemLink");
                }

            });

        }

        $(function () {
            attachEvents();
        });


    </script>
    <style type="text/css">
        body
        {
            background-color: black;
        }
        a
        {
            text-decoration: underline;
            color: #0087C7;
        }
        
        a:hover
        {
            text-decoration: underline;
            color: #00C713;
        }
        
        .hidden
        {
            display: none;
        }
        
        .mGridSimple
        {
            width: 100%;
            margin: 0px 0 0px 0;
            border-style: none;
            border-collapse: collapse;
            border-spacing: 1px;
        }
        .mGridSimple td
        {
            padding: 0px;
            border-style: none;
            color: #717171;
        }
        .mGridSimple th
        {
            padding: 0px;
            border-style: none;
            color: #717171;
            text-align: right;
            border-bottom-style: solid;
        }
        
        .surveyDisplayDiv
        {
            background-color: #222;
            border-radius: 10px;
            padding: 4px;
            width: 250px;
        }
        
        .surveyResultsDisplayDiv
        {
            background-color: #222;
            border-radius: 10px;
            padding: 4px;
            width: 250px;
        }
        
        .addItem
        {
            padding: 5px;
        }
        
        .total
        {
            float: right;
            color: White;
        }
        
        .percentageBar
        {
            height: 10px;
            background-color: #0087C7;
            font-size: 11px;
            color: Black;
            padding: 0px;
            display: inline-block;
            position: relative;
            top: -7px;
        }
        
        .percentageText
        {
            height: 10px;
            font-size: 11px;
            color: white;
            padding: 0px;
            position: relative;
            top: -7px;
        }
        
        .resultsItem
        {
            color: #aaa;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="fullPage">
        <div class="surveyDisplayDiv">
            <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                DataSourceID="SqlDataSource1" Width="250px" EnableViewState="false" ShowHeader="True"
                BorderStyle="none" BorderWidth="0px" RowStyle-BorderWidth="0px" CssClass="mGridSimple">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <a href="#" class="resultsLink">Results</a> | <a href="#" class="backLink">Home</a>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <a href="<%# Eval("item")%>" class="itemLink hidden item" title="<%# Eval("subItem")%>">
                                <span class="itemText">
                                    <%# Eval("item")%></span><%# Eval("subItem")%></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:COLORConnectionString %>"
                SelectCommand="select * from itemsurveyitems order by item, subitem" SelectCommandType="Text">
                <SelectParameters>
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <div class="addItem hidden">
            <input id="newItem" /><a id="newItemLink" href="#">Add New</a>
        </div>
    </div>
    </form>
</body>
</html>
