//Function: sets initial cookie values for token and nickname
function setCookie(token,nickname){
    if (!(getCookie("token")) || getCookie("token") == ""){
        createCookie("token",token);
    }
    if (!(getCookie("nickname")) || getCookie("nickname") == ""){
        createCookie("nickname",nickname);
    }
    window.location.replace("/");
}

//Function: Creates a cookie with the given name, value and expiration date
var createCookie = function(name, value) {
    var expires;
    var date = new Date();
    date.setTime(date.getTime() + (60 * 60 * 1000));
    expires = "; expires=" + date.toGMTString();
    document.cookie = name + "=" + value + expires + "; path=/";
}

//Function: Gets the value for a given cookie name
function getCookie(c_name) {
    if (document.cookie.length > 0) {
        var c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            var c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = document.cookie.length;
            }
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return "";
}

//Function: Erases the cookie value of the cookies
function eraseCookie(){
    document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "nickname=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "submitid=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "teamkey=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "draftStatus=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "week=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "playoffStart=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "playoffEnd=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    return true;
}

//Function: Checks if user is logged in
function checkLogin(){
    if (getCookie("token") != ""){
        window.location.replace("/");
    }
}

//Function: Checks if all the required cookie values are there
function indexCheck(){
    if (!(getCookie("submitid")) || getCookie("submitid") == ""){
        document.getElementById("options").style.display="none";
    }
    if (!(getCookie("teamkey")) || getCookie("teamkey") == ""){
        document.getElementById("teamElement").style.display="none";
    }
    if (getCookie("draftStatus") && getCookie("draftStatus") != "postdraft"){
        document.getElementById("players").value="Live Draft";
    }
    if (getCookie("token") != ""){
        document.getElementById("token").value = getCookie("token");
    } else {
        window.location.replace("/login")
    }
    if (getCookie("nickname") != ""){
        document.getElementById("nickname").innerHTML = "Welcome " + getCookie("nickname");
    } 
}

//Function: checks if all the required cookies for home page are there
function indexCheckHome(){
    if (getCookie("token") != ""){
        var token = getCookie("token")
        window.location.replace("/home?token=" + token)
    } else {
        window.location.replace("/login")
    }
}

//Function: Creates cookies for team, then runs indecheck
function indexCheck_plusTeam(teamKey,draftStatus,playoffStart,playoffEnd){
    createCookie('teamkey',teamKey);
    createCookie('draftStatus',draftStatus);
    createCookie('playoffStart',playoffStart);
    createCookie('playoffEnd',playoffEnd);
    indexCheck();
}

//Function: gets home page info
function getHomeInfo(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("hToken").value = getCookie("token");
    }
}

//Function: gets league info
function getLeagueInfo(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
}

//Function: gets roster page info
function getRosterInfo(){
    if (getCookie("token") && getCookie("token") != ""){
        var token = document.getElementsByClassName("rToken");
        for (var i = 0; i < token.length; i++) {
            token[i].value = getCookie("token");
        }
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        var leagueid = document.getElementsByClassName("rsubmitID");
        for (var i = 0; i < leagueid.length; i++) {
            leagueid[i].value = getCookie("submitid");
        }
    }
}

//Function: gets free agents page info
function getFreeAgentInfo(){
    document.cookie = "week=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.getElementById("options").action = '/freeagents';
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
    if (getCookie("draftStatus") && getCookie("draftStatus") != ""){
        document.getElementById("lState").value = getCookie("draftStatus");
        document.getElementById("lState").name = "state";
    }
    if (getCookie("playoffStart") && getCookie("playoffStart") != ""){
        document.getElementById("lStart").value = getCookie("playoffStart");
        document.getElementById("lStart").name = "pStart";
    }
    if (getCookie("playoffEnd") && getCookie("playoffEnd") != ""){
        document.getElementById("lEnd").value = getCookie("playoffEnd");
        document.getElementById("lEnd").name = "pEnd";
    }
}

//Function: gets standings info
function getStandings(){
    document.getElementById("options").action = '/standings';
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
}

//Function: gets team info
function getTeamInfo(){ 
    document.getElementById("options").action = '/roster';
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
    if (getCookie("teamkey") && getCookie("teamkey") != ""){
        document.getElementById("lTeam").value = getCookie("teamkey");
        document.getElementById("lTeam").name = "team";
    }
    if (getCookie("playoffStart") && getCookie("playoffStart") != ""){
        document.getElementById("lStart").value = getCookie("playoffStart");
        document.getElementById("lStart").name = "pStart";
    }
    if (getCookie("playoffEnd") && getCookie("playoffEnd") != ""){
        document.getElementById("lEnd").value = getCookie("playoffEnd");
        document.getElementById("lEnd").name = "pEnd";
    }
}

//Function: gets team info
function getTeamInfo2(){ 
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("wToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("wsubmitID").value = getCookie("submitid");
    }
    if (getCookie("teamkey") && getCookie("teamkey") != ""){
        document.getElementById("wTeam").value = getCookie("teamkey");
    }
    if (getCookie("playoffStart") && getCookie("playoffStart") != ""){
        document.getElementById("wStart").value = getCookie("playoffStart");
        document.getElementById("wStart").name = "pStart";
    }
    if (getCookie("playoffEnd") && getCookie("playoffEnd") != ""){
        document.getElementById("wEnd").value = getCookie("playoffEnd");
        document.getElementById("wEnd").name = "pEnd";
    }
    if (getCookie("week") && getCookie("week") != ""){
        document.getElementById("wWeek").value = getCookie("week");
    }
}

//Function: gets free agents page info
function getFreeAgentInfo2(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("fToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("fsubmitID").value = getCookie("submitid");
    }
    if (getCookie("draftStatus") && getCookie("draftStatus") != ""){
        document.getElementById("fState").value = getCookie("draftStatus");
    }
    if (getCookie("playoffStart") && getCookie("playoffStart") != ""){
        document.getElementById("fStart").value = getCookie("playoffStart");
        document.getElementById("fStart").name = "pStart";
    }
    if (getCookie("playoffEnd") && getCookie("playoffEnd") != ""){
        document.getElementById("fEnd").value = getCookie("playoffEnd");
        document.getElementById("fEnd").name = "pEnd";
    }
    if (getCookie("week") && getCookie("week") != ""){
        document.getElementById("fWeek").value = getCookie("week");
    }
}

//Function: gets free agents page info
function getFreeAgentInfo3(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("wToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("wsubmitID").value = getCookie("submitid");
    }
    if (getCookie("draftStatus") && getCookie("draftStatus") != ""){
        document.getElementById("wState").value = getCookie("draftStatus");
    }
    if (getCookie("playoffStart") && getCookie("playoffStart") != ""){
        document.getElementById("wStart").value = getCookie("playoffStart");
        document.getElementById("wStart").name = "pStart";
    }
    if (getCookie("playoffEnd") && getCookie("playoffEnd") != ""){
        document.getElementById("wEnd").value = getCookie("playoffEnd");
        document.getElementById("wEnd").name = "pEnd";
    }
    if (getCookie("week") && getCookie("week") != ""){
        document.getElementById("wWeek").value = getCookie("week");
    }
}


//Function: sets position in freeagency
function setPosition(pos){
    getFreeAgentInfo2();
    document.getElementById("positions").action = "http://www.fantasyhockeyhelper.com/freeagents" + pos;
}

//Function: sets week in roster
function setWeek(week){
    createCookie('week',week);
    getTeamInfo2();
}

//Function: sets week in free agency
function setWeekFA(week){
    createCookie('week',week);
    getFreeAgentInfo3();
}

//Function: sets position in rankings
function setDPosition(pos){
    document.getElementById("positions").action = "http://www.fantasyhockeyhelper.com/rankings" + pos;
}

//Function: sets what league is being viewed
function setLeague(leagueid){
    createCookie('submitid',leagueid);
    document.getElementById("submitID").value = getCookie("submitid");
}