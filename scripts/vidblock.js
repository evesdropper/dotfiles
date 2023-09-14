// allowList - only school channels
const allowList = ["UCzEkG13m_C7bYsNZPNSRRJw", "UCfMDPomfBL5yMAOpwVnP07w", "UCp3c2TP4KMrEtavjokkSpyw"]; // 182, 202a, 161

// greyList - for off work
const greyList = [];

// tz changer because daylight savings exists - ref: https://stackoverflow.com/a/53652131
function changeTimezone(date, ianatz) {

  // suppose the date is 12:00 UTC
  var invdate = new Date(date.toLocaleString('en-US', {
    timeZone: ianatz
  }));

  // then invdate will be 07:00 in Toronto
  // and the diff is 5 hours
  var diff = date.getTime() - invdate.getTime();

  // so 12:00 in Toronto is 17:00 UTC
  return new Date(date.getTime() - diff); // needs to subtract
}

// video blocker
(video, objectType) => {
    // check time: if free time schedule
    var rawDate = new Date;
    var Date = changeTimezone(rawDate, "America/Los_Angeles");
    var day = date.getDay();
    var hour = date.getHours();

    // if channelid is on allowList
    if (allowList.includes(video.channelId)) {
        return false;
    }

    // free time: dinner 6-8PM
    if (18 <= hour <= 19) && (greyList.includes(video.channelid)) {
        return false;
    }
    return true;
}


