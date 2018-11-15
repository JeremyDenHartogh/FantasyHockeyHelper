//Function: Creates a cookie with the given name, value and expiration date
function setCookie(token,nickname){
    if (!(getCookie("token")) || getCookie("token") == ""){
        createCookie("token",token);
    }
    if (!(getCookie("nickname")) || getCookie("nickname") == ""){
        createCookie("nickname",nickname);
    }
    window.location.replace("/");
}

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

//Function: Erases the cookie value of the username cookie
function eraseCookie(){
    document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "nickname=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "submitid=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    document.cookie = "teamkey=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    return true;
}

function checkLogin(){
    if (getCookie("token") != ""){
        window.location.replace("/");
    }
}

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

function indexCheckHome(){
    if (getCookie("token") != ""){
        var token = getCookie("token")
        window.location.replace("/home?token=" + token)
    } else {
        window.location.replace("/login")
    }
}

function indexCheck_plusTeam(teamKey,draftStatus){
    createCookie('teamkey',teamKey);
    createCookie('draftStatus',draftStatus);
    indexCheck();
}

function getHomeInfo(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("hToken").value = getCookie("token");
    }
}

function getLeagueInfo(){
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
}

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

function getFreeAgentInfo(){
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
}

function getStandings(){
    document.getElementById("options").action = '/standings';
    if (getCookie("token") && getCookie("token") != ""){
        document.getElementById("lToken").value = getCookie("token");
    }
    if (getCookie("submitid") && getCookie("submitid") != ""){
        document.getElementById("lsubmitID").value = getCookie("submitid");
    }
}

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
}

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
}

function setPosition(pos){
    getFreeAgentInfo2();
    document.getElementById("positions").action = "http://www.fantasyhockeyhelper.com/freeagents" + pos;
}

function setDPosition(pos){
    document.getElementById("positions").action = "http://www.fantasyhockeyhelper.com/rankings" + pos;
}

function setLeague(leagueid){
    createCookie('submitid',leagueid);
    document.getElementById("submitID").value = getCookie("submitid");
}