@echo off
rem
rem ==========================================================================
rem = Licensed to the Apache Software Foundation (ASF) under one or more
rem = contributor license agreements.  See the NOTICE file distributed with
rem = this work for additional information regarding copyright ownership.
rem = The ASF licenses this file to You under the Apache License, Version 2.0
rem = (the "License"); you may not use this file except in compliance with
rem = the License.  You may obtain a copy of the License at
rem =
rem =     http://www.apache.org/licenses/LICENSE-2.0
rem =
rem = Unless required by applicable law or agreed to in writing, software
rem = distributed under the License is distributed on an "AS IS" BASIS,
rem = WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem = See the License for the specific language governing permissions and
rem = limitations under the License.
rem ==========================================================================
rem
rem     build.bat: Build Xalan-J 2.x using Ant 
rem     Usage: build [ant-options] [targets]
rem     Setup:
rem         - you should set JAVA_HOME
rem         - you can set ANT_HOME if you use your own Ant install
rem         - JAVA_OPTS is added to the java command line
rem         - PARSER_JAR may be set to use alternate parser (default:lib\endorsed\xercesImpl.jar)
echo.
echo Xalan-J 2.x Build
echo -------------

if not "%JAVA_HOME%" == "" goto setant
:noJavaHome
rem Default command used to call java.exe; hopefully it's on the path here
if "%_JAVACMD%" == "" set _JAVACMD=java
echo.
echo Warning: JAVA_HOME environment variable is not set.
echo   If build fails because sun.* classes could not be found
echo   you will need to set the JAVA_HOME environment variable
echo   to the installation directory of java.
echo.

:setant
rem Default command used to call java.exe or equivalent
if "%_JAVACMD%" == "" set _JAVACMD=%JAVA_HOME%\bin\java

rem Default ANT_HOME to the one what user has set
if not "%ANT_HOME%"=="" set _ANT_HOME=%ANT_HOME%
if "%ANT_HOME%"=="" set _ANT_HOME=.

if EXIST "%_ANT_HOME%\tools\ant.jar" (
   set _ANT_JARS=%_ANT_HOME%\tools\ant.jar
) else (
   set _ANT_JARS=%_ANT_HOME%\lib\ant.jar;%_ANT_HOME%\lib\ant-launcher.jar
)

rem Default locations of jars we depend on to run Ant on our build.xml file
rem Set our local vars to all start with _underscore
set _PARSER_JAR=%PARSER_JAR%
if "%_PARSER_JAR%" == "" set _PARSER_JAR=lib\endorsed\xercesImpl.jar
set _XML-APIS_JAR=%XML-APIS_JAR%
if "%_XML-APIS_JAR%" == "" set _XML-APIS_JAR=lib\endorsed\xml-apis.jar

rem Attempt to automatically add system classes to _CLASSPATH
rem Use _underscore prefix to not conflict with user's settings
set _CLASSPATH=%CLASSPATH%
if exist "%JAVA_HOME%\lib\tools.jar" set _CLASSPATH=%CLASSPATH%;%JAVA_HOME%\lib\tools.jar
if exist "%JAVA_HOME%\lib\classes.zip" set _CLASSPATH=%CLASSPATH%;%JAVA_HOME%\lib\classes.zip
set _CLASSPATH=%_ANT_JARS%;%_XML-APIS_JAR%;%_PARSER_JAR%;%_CLASSPATH%

@echo on
"%_JAVACMD%" -mx1024m %JAVA_OPTS% -Dant.home="%ANT_HOME%" -classpath "%_CLASSPATH%" org.apache.tools.ant.Main %1 %2 %3 %4 %5 %6 %7 %8 %9
@echo off

goto end

:end
rem Cleanup environment variables
set _JAVACMD=
set _CLASSPATH=
set _ANT_HOME=
set _ANT_JARS=
set _PARSER_JAR=
set _XML-APIS_JAR=

