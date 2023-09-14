// allowList - only school channels
const allowList = ["UCzEkG13m_C7bYsNZPNSRRJw", "UCfMDPomfBL5yMAOpwVnP07w", "UCp3c2TP4KMrEtavjokkSpyw"]; // 182, 202a, 161

(video, objectType) => {
    // check time: if free time schedule
    var date = new Date;
    var day = date.getDay();
    var hour = date.getHours();

    // if channelid is on allowList
    if (allowList.includes(video.channelId)) {
        return false;
    }
    return true;
}
