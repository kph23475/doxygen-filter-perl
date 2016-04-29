#!/bin/bash
#
# @htmlonly doxygen comment markup introduced by
# doxygen-filter-perl.
#
# `# @htmlonly` usage results in `* <br>` placement upon
# each line
#
# remove unwanted leading ' ', '*', '<br>' from @htmlonly
# blocks
#
# Example @htmlonly block Perl source input
#
#   #** @date 2016.04.25
#   #*
#   #** @copyright  Copyright (C) 2016, An author. All Rights Reserved.
#   #*
#   #** @see SomePackage
#   #*
#
#   #** @class MyRecord
#   #*
#   #** @brief Storage for database View query information.
#   #*
#   #** @details Record layout or storage for desired entries in database containing desired information. 
#   # Each instance variable name equals name of a View within database, with each View containing a single 
#   # record.
#   #
#   #** @htmlonly 
#   # <p>All instance variables: 
#   # <ul>                    
#   # <li>Defined in configuration apart from source. <a href="http:#search.cpan.org/perldoc/Config::Tiny">Config::Tiny</a> 
#   # <li>Represent information from database for ease of conversion into JSON, provison of indirection for database layout. 
#   # </ul> 
#   # <table border=1>
#   # <tr><td> Hash </td> 
#   #     <td> Data </td> 
#   #     <td> Note </td></tr>
#   # <tr><td> <code>$this->{last_update} </code>                   </td> 
#   #     <td> '2016.04.02 13:44:51'                                </td> 
#   #     <td> status information from database View `last_update`  </td></tr>
#   # <tr><td> <code>$this->{sensor01}{status}</code>        </td> 
#   #     <td> 'OK' or 'Alert'                               </td> 
#   # <td> from View `sensor01`                              </td></tr>
#   # <tr><td> <code>$this->{sensor01}{moment}</code>        </td> 
#   #     <td colpsan=2>  '2016.04.02 13:45:03'              </td></tr>
#   # </table>
#   # <div>Example:<p>
#   # <code>my $MyRecord = SomePackage::MyRecord->new();<p>
#   # $statusRecord->{'sensor01'}{'description'}="This sensor";<p>
#   # print $statusRecord->{sensor01}{'description'};<p>
#   # &gt;This Sensor</code></div>
#   #** @endhtmlonly
#
#
# 2016.04.29 - Kevin.Hatfield@gmail.com
#
./bin/doxygen-filter-perl $1                     \
| /usr/bin/awk       'function removeLineBreak(lineIn)
                      {
			 gsub(/^[\t* ]{0,}(<br>){0,}/,"",lineIn);
                         print lineIn;
                      }
                      BEGIN{ htmltag=0;}
                      {
                      if ($0 ~ /@htmlonly/)
                      {
                         htmltagfound=1;
                         removeLineBreak($0);
                      }
                      else if (htmltagfound==1)
                      {
                         removeLineBreak($0);
                      }
                      else if ($0 ~ /@endhtmlonly/)
                      {
                         htmltagfound=0;
                         removeLineBreak($0);
                      }
                      else
                      {
			 lineout=$0;
			 if (lineout ~ /<br>/)
		         {
			    gsub(/^[ *]<br>|^[ *]<br>|^[ *]{0,}(<br>){1,}/,"<span>",lineout);
			    gsub(/(<span>){2,}/,"<span>",lineout);
			    if (lineout !~ /\n[^a-zA-Z0-9.+-_]/ && lineout !~ /<span><\span>|<p><p>/)
			    {
			       if (lineout ~ /<span>/){ print lineout"</span>"; }else{ print lineout;}
		            }
			 }
                         else
		         {
		            print lineout;
		         }
                      }
                      }';
