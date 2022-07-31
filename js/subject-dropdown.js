var trends = document.querySelector('body > form > table > tbody > tr:nth-child(2) > td:nth-child(2) > select'), i;

const data = new Map();

for (i = 0; i < trends.length; i++) {
    data.set(trends[i].value, trends[i].text);
}
console.table(Array.from(data.entries()))

