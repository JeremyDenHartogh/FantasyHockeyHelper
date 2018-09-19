var ascT = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];

function sort_table(col){
    var tbody = document.getElementById("rankings");
    var asc = ascT[col];   
    ascT[col] *= -1;
    var rows = tbody.rows;
    var rlen = rows.length;
    var arr = new Array();
    var i, j, cells, clen;
    // fill the array with values from the table
    for(i = 0; i < rlen; i++)
    {
        cells = rows[i].cells;
        clen = cells.length;
        arr[i] = new Array();
      for(j = 0; j < clen; j++) { arr[i][j] = cells[j].innerHTML; }
    }
    // sort the array by the specified column number (col) and order (asc)
    arr.sort(function(a, b)
    {
        var retval=0;
        var fA=parseFloat(a[col]);
        var fB=parseFloat(b[col]);
        if(a[col] != b[col])
        {
            if((fA==a[col]) && (fB==b[col]) ){ retval=( fA > fB ) ? -asc : asc; } //numerical
            else { retval=(a[col] > b[col]) ? asc : -1*asc;}
        }
        return retval;      
    });
    for(var rowidx=0;rowidx<rlen;rowidx++)
    {
        for(var colidx=0;colidx<arr[rowidx].length;colidx++){ tbody.rows[rowidx].cells[colidx].innerHTML=arr[rowidx][colidx]; }
    }
}