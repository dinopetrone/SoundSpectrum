/*
*
*    ResourceManager - Resource Loader.
*    Copyright (C) 2009 BLITZ Digital Studios LLC d/b/a BLITZ Agency.
*
*    This library is free software; you can redistribute it and/or modify it 
*    under the terms of the GNU Lesser General Public License as published
*    by the Free Software Foundation; either version 2.1 of the License, or 
*    (at your option) any later version.
*
*    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
*    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
*    PURPOSE. See the GNU Lesser General Public License for more details.
*
*    You should have received a copy of the GNU Lesser General Public License along 
*    with this library; if not, write to the Free Software Foundation, Inc.,
*    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
*
*    BLTIZ Digital Studios LLC, 3415 S. Sepulveda BLVD, Ste 500, Los Angeles CA, 90034
*    http://www.blitzagency.com
*    http://labs.blitzagency.com
*
*        Author: Adam Venturella - aventurella@blitzagency.com
*
*/
package com.blitzagency.utils
{
	public function ElfHash(input:String):int
	{
		var hash   : int = 0;
		var x      : int = 0;
		var strlen : int = input.length;
		
		for(var i : int = 0; i < strlen; i++)
		{
			hash = (hash << 4) + input.charCodeAt(i);
			
			x = hash & 0xF0000000;
			if(x != 0)
				hash ^= (x >> 24);
			hash &= ~x;
		}
		
		return hash;
	}
}