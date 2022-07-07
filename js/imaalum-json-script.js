// Works on https://imaluum.iium.edu.my/MyAcademic/schedule

var tableBody = document.getElementsByClassName("table table-hover")[0];
var data = tableBody.getElementsByTagName("tr");

var nullIndex = new Array();
var courseCodes = new Array();
var sections = new Array();
var combinedSubjectDatas = new Array();

// section
for (let i = 1; i < data.length; i++) {
    // add unnecessary rows to unwanted array
    if (data[i].cells[2].getAttribute("rowspan") === null) nullIndex.push(i);
    // only extract the correct rows
    else sections.push(parseInt(data[i].cells[2].innerText));
}

// course code
for (let i = 1; i < data.length; i++) {
    // extract course code except the rows in unwanted array
    if (!nullIndex.includes(i)) courseCodes.push(data[i].cells[0].innerText);
}

// combine code & section
for (i = 0; i < sections.length; i++) {
    combinedSubjectDatas.push({
        courseCode: courseCodes[i],
        section: sections[i],
    });
}

var json = JSON.stringify(combinedSubjectDatas); // data
const myUrl = new URL('https://iiumschedule.iqfareez.com/qrcode');
myUrl.searchParams.append('data', json);
console.log(myUrl.href); // log target url
window.open(myUrl.href); // go to target url