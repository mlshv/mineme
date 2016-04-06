<%@ page import="classes.DBManager" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    DBManager dbManager = new DBManager();
%>
<!DOCTYPE HTML>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MineMe</title>
    <link rel="stylesheet" href="css/uikit.min.css">
    <link rel="stylesheet" href="css/uikit.gradient.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/mineme.css">
    <link rel="icon" type="image/png" href="img/favicon.ico" />
    <script src="js/jquery.js"></script>
    <script src="js/uikit.min.js"></script>
</head>
<body>
<!-- I use these hidden tags to get data from the server because it much faster then XmlHttpRequest -->
<div hidden id="server-timestamp"><%= new Date().getTime() %></div>
<div hidden id="last-events"><%= dbManager.getLastEventsJson(8, true) %></div>
<div hidden id="struct-data"><%= dbManager.getStruct() %></div>

<nav class="uk-navbar uk-margin-large-bottom uk-navbar-attached">
    <div class="uk-container uk-container-center">
        <div class="uk-navbar-brand">MineMe</div>
        <ul class="uk-navbar-nav">
            <li><a href="add-event.jsp">Добавить событие</a></li>
        </ul>
    </div>
</nav>
<div class="uk-container uk-container-center uk-margin-top uk-margin-large-bottom">
    <div class="uk-grid" data-uk-grid-match>
        <div class="uk-width-large-1-2 uk-width-medium-1-1 uk-margin-large-bottom">
            <div class="uk-panel uk-panel-box">
                <div class="uk-display-block uk-comment-meta">
                    <img class="uk-comment-avatar uk-border-rounded" src="img/profile.png" alt="Avatar" width="59">
                    <h1 class="uk-comment-title">Малышев Михаил</h1>
                    <div class="uk-comment-meta">
                        <a href="https://github.com/logzee" class="uk-icon-button uk-icon-github"></a>
                        <a href="http://vk.com/logzee" class="uk-icon-button uk-icon-vk"></a>
                        <a href="https://www.instagram.com/miwanya_vidit/" class="uk-icon-button uk-icon-instagram"></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="uk-width-large-1-2 uk-width-medium-1-1">
            <div class="uk-panel uk-panel-box">
                <h1 class="uk-panel-title">Последние события</h1>
                <dl class="uk-list uk-list-line uk-description-list-line" id="event-log">
                </dl>
            </div>
            <p><a href="event-list.jsp">Все события</a></p>
        </div>
    </div>
    <hr>
    <h2>Как менялось настроение за последние 7 дней</h2>
    <div id="mood_chart"></div>
    <h2>Активность за компьютером за последние 7 дней</h2>
    <div id="comp_chart"></div>
</div>
<script src="js/index.js" language="Javascript" type="text/javascript"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    google.charts.load('current', {packages: ['corechart', 'line']});
    google.charts.setOnLoadCallback(drawCharts);

    function drawCharts() {
        drawKeyloggerChart();
        drawMoodChart();
    }
    function drawMoodChart() {
        var xhr = new XMLHttpRequest();
        // method = getEventsByType, type=1 (настроение), msAgo = 604800000 (неделя)
        xhr.open('GET', 'data?method=getEventsByType&type=1&msAgo=604800000', false);
        xhr.send();

        var moodData = JSON.parse(xhr.responseText);
        var dataRows = [];
        for (var i = 0; i < moodData.length; i++) {
            var date = parseInt(moodData[i].date);
            var value = parseInt(moodData[i].chain[1]);
            dataRows.push([new Date(date), value]);
        }

        // Define the chart to be drawn.
        var data = new google.visualization.DataTable();

        data.addColumn('date', 'Дата');
        data.addColumn('number', 'Настроение');
        data.addRows(dataRows);

        var options = {
            hAxis: {
                title: 'Дата'
            },
            curveType: 'function',
            vAxis: {
                title: 'Настроение'
            },
            legend: { position: 'bottom' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('mood_chart'));

        chart.draw(data, options);
    }


    function drawKeyloggerChart() {
        var xhr = new XMLHttpRequest();

        xhr.open('GET', 'data?method=getEventsByType&type=4&msAgo=604800000', false);
        xhr.send();

        var keyloggerData = JSON.parse(xhr.responseText);
        debugger;
        dataRows = [];
        for (var i = 0; i < keyloggerData.length; i++) {
            var date = parseInt(keyloggerData[i].date);
            var value = parseInt(keyloggerData[i].chain[1]);
            dataRows.push([new Date(date), value]);
        }

        // Define the chart to be drawn.
        var data = new google.visualization.DataTable();

        data.addColumn('date', 'Дата');
        data.addColumn('number', 'Нажатий клавиш');
        data.addRows(dataRows);

        var options = {
            hAxis: {
                title: 'Дата'
            },
            curveType: 'function',
            vAxis: {
                title: 'Активность'
            },
            legend: { position: 'bottom' }
        };

        var comp_chart = new google.visualization.LineChart(document.getElementById('comp_chart'));

        comp_chart.draw(data, options);
    }
</script>
</body>
</html>