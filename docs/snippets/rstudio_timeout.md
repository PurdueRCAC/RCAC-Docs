**Problem**

RStudio Server times out after approximately 60 minutes of inactivity. Upon re-entering the session, there will be a "RStudio Server Login Required" window popping up as below.

<td style="text-align: center;">
    <img src="/assets/images/userguides/rstudio_timeout1.png" alt="Rstudio login required">
</td>

When trying to log in from the login window below, your login credentials **WILL NOT** work.

<td style="text-align: center;">
    <img src="/assets/images/userguides/rstudio_timeout2.png" alt="Rstudio login window">
</td>

**Solution**

This issue is related to the RStudio Server configuration that sessions will automatically log out if inactive for over **60 minutes**. The solution would be either to keep active every 60 minutes or use the user name and password (session specific password) described as follows to re-login:

1. Navigate to the current RStudio session in Open OnDemand.

    <td style="text-align: center;">
        <img src="/assets/images/userguides/rstudio_timeout3.png" alt="Rstudio session ID" width="90%">
    </td>

2. Click on the session ID to open the session folder and locate the `connection.yml` file within the session folder.

    <td style="text-align: center;">
        <img src="/assets/images/userguides/rstudio_timeout4.png" alt="Rstudio session folder" width="90%">
    </td>

3. Open it to find the session-specific password. 

    ```
    csrf_token: ***************
    host: a007.cluster.rcac.purdue.edu
    port: 5329
    password: ***************
    ```

4. Then, use your Purdue account username in the "Username" field and the password retrieved from the `connection.yml` file to re-login.

P.S. If you could not open the page after re-login (see below) and saw the web url ended with `/appUri`, delete `/appUri` and retry with the remaining url. 

<td style="text-align: center;">
    <img src="/assets/images/userguides/rstudio_timeout5.png" alt="Rstudio URL mismatch">
</td>











