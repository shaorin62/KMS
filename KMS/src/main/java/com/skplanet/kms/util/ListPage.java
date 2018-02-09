package com.skplanet.kms.util;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;

public class ListPage {

	public static final int DEFAULT_PAGE_SIZE = 10;
	public static final int DEFAULT_LIST_SIZE = 10;
	
	int pageSize = DEFAULT_PAGE_SIZE;		// 페이징부분에 보여줄 한페이지당 최대 페이지 수 (<< < 1 2 3 4 5 6 7 8 9 10 > >>)'
	int listSize = DEFAULT_LIST_SIZE;	// 한페이지에 보여줄 게시물 수
	int totalCount;
	int currentPage;
	int totalPage;
	List list;
	String pageString = "";
	
	int firstRow;
	int lastRow;
	
	public ListPage(int pageSize, int listSize, String currentPage) {
		this.pageSize = pageSize;
		this.listSize = listSize;

		this.currentPage = NumberUtils.toInt(currentPage, 1);
		
		firstRow = listSize * (this.currentPage-1)+1;
		lastRow = listSize * (this.currentPage);
	}
	
	public ListPage(int listSize, String currentPage) {
		this(DEFAULT_PAGE_SIZE, listSize, currentPage);
	}
	
	public ListPage(String currentPage) {
		this(DEFAULT_PAGE_SIZE, DEFAULT_LIST_SIZE, currentPage);
	}
	
	public int getListSize() {
		return listSize;
	}
	public void setListSize(int listSize) {
		this.listSize = listSize;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		
		totalPage = totalCount / listSize;
		if(totalCount % listSize > 0) totalPage++;
		pageString = makePageString();		
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public List getList() {
		return list;
	}
	public void setList(List list) {
		this.list = list;
	}
	public String getPageString() {
		return pageString;
	}
	public void setPageString(String pageString) {
		this.pageString = pageString;
	}
	public int getFirstRow() {
		return firstRow;
	}
	public void setFirstIndex(int firstRow) {
		this.firstRow = firstRow;
	}
	public int getLastRow() {
		return lastRow;
	}
	public void setLastRow(int lastRow) {
		this.lastRow = lastRow;
	}
	
	private static final String functionName = "goPage";	// 페이지에 링크할 함수명(자바스크립트)
	/*
	private static final String firstHtml = "<button type='button' onclick=\""+functionName+"('1');\"> &lt;&lt; </button>\r\n";
	private static final String firstXHtml = "<button type='button' onclick=\"\" disabled='disabled'> &lt;&lt; </button>\r\n";
	private static final String prevHtml = "<button type='button' onclick=\""+functionName+"('@');\"> &lt; </button>\r\n";
	private static final String prevXHtml = "<button type='button' onclick=\"\" disabled='disabled'> &lt; </button>\r\n";
	private static final String nowHtml = "<button type='button' class='this' onclick=\"\" disabled='disabled'>@</button>\r\n";
	private static final String pageHtml = "<button type='button' onclick=\""+functionName+"('@');\">@</button>\r\n";
	private static final String nextHtml = "<button type='button' onclick=\""+functionName+"('@');\"> &gt; </button>\r\n";
	private static final String nextXHtml = "<button type='button' onclick=\"\" disabled='disabled'> &gt; </button>\r\n";
	private static final String lastHtml = "<button type='button' onclick=\""+functionName+"('@');\"> &gt;&gt; </button>\r\n";
	private static final String lastXHtml = "<button type='button' onclick=\"\" disabled='disabled'> &gt;&gt; </button>\r\n";
	*/
	
	private static final String firstHtml = "<button type='button' onclick=\""+functionName+"('1');\"><img src='/resources/images/paging_begin.png' alt='begin'></button>\r\n";
	private static final String firstXHtml = "<button type='button' disabled='disabled'><img src='/resources/images/paging_begin.png' alt='begin'></button>\r\n";
	private static final String prevHtml = "<button type='button' onclick=\""+functionName+"('@');\"><img src='/resources/images/paging_prev.png' alt='preview'></button>\r\n";
	private static final String prevXHtml = "<button type='button' onclick=\"\" disabled='disabled'><img src='/resources/images/paging_prev.png' alt='preview'></button>\r\n";	
	private static final String nowHtml = "<button type='button' class='this' onclick=\"\" disabled='disabled'>@</button>\r\n";
	private static final String pageHtml = "<button type='button' onclick=\""+functionName+"('@');\">@</button>\r\n";
	private static final String nextHtml = "<button type='button' onclick=\""+functionName+"('@');\"><img src='/resources/images/paging_next.png' alt='next'></button>\r\n";
	private static final String nextXHtml = "<button type='button' onclick=\"\" disabled='disabled'><img src='/resources/images/paging_next.png' alt='next'></button>\r\n";
	private static final String lastHtml = "<button type='button' onclick=\""+functionName+"('@');\"><img src='/resources/images/paging_end.png' alt='end'></button>\r\n";
	private static final String lastXHtml = "<button type='button' onclick=\"\" disabled='disabled'><img src='/resources/images/paging_end.png' alt='end'></button>\r\n";
	
	private String makePageString(){
		
		if(totalCount == 0) return "";

		StringBuffer sb = new StringBuffer();
		int currentFirst = (currentPage-1)/pageSize;		// 현재 페이지 에서 첫번째 페이지 번호 구하기
		currentFirst = currentFirst * pageSize + 1;
		int currentlast = (currentPage-1)/pageSize;		//  현재 페이지 에서 마지막 페이지 번호 구하기
		currentlast = currentlast * pageSize + pageSize;
		int nextFirst = (currentPage-1)/pageSize;			// 현재 페이지 에서 다음 블럭 페이지 번호 구하기
		nextFirst = (nextFirst+1) * pageSize + 1; 
		int prevLast = (currentPage-1)/pageSize;			// 현재 페이지 에서 이전 블럭 페이지 번호 구하기
		prevLast = (prevLast-1) * pageSize + pageSize ;
		int lastPage = 1;											
		lastPage = totalCount / listSize;
		if ( totalCount%listSize != 0 ) lastPage = lastPage + 1;
		currentlast = (currentlast>lastPage)?lastPage:currentlast;	
		
		if ( currentPage>1 ) {
			sb.append( firstHtml );
		}else{
			sb.append( firstXHtml );
		}
		
		
		if ( prevLast > 0 ) {
			sb.append( StringUtils.replace(prevHtml,"@", String.valueOf(prevLast)));
		}else{
			sb.append( StringUtils.replace(prevXHtml,"@", String.valueOf(prevLast)));
		}
			
		sb.append("<span>");
		for (int j=currentFirst; j<currentFirst+pageSize && j<=lastPage; j++) {	
			if ( j <= currentlast ) {
				if ( j == currentPage ) {
					sb.append( StringUtils.replace(nowHtml,"@", String.valueOf(j)));
				} else {
					sb.append( StringUtils.replace(pageHtml,"@", String.valueOf(j)));
				}
			} 
		}
		sb.append("</span>");
		if ( nextFirst > lastPage ) {   nextFirst = lastPage ;  }
		if(currentlast < totalPage) {
			sb.append( StringUtils.replace(nextHtml,"@", String.valueOf(nextFirst)));
		}else{
			sb.append( StringUtils.replace(nextXHtml,"@", String.valueOf(nextFirst)));
		}
		
		if ( currentPage < lastPage ) {
			sb.append( StringUtils.replace(lastHtml,"@", String.valueOf(lastPage)));
		}else{
			sb.append( StringUtils.replace(lastXHtml,"@", String.valueOf(lastPage)));
		}
		
		return sb.toString();
	}	
}
