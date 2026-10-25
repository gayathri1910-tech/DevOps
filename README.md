# TriggerFlow — DevOps Lab Project

## Project objective
Demonstrate event-driven CI/CD using GitHub, Jenkins and Docker. A pipeline validates files, builds a container image, replaces the running container, and performs an HTTP smoke test.

## Files
- `index.html`, `style.css`: sample web application
- `Dockerfile`: Nginx-based container image
- `Jenkinsfile`: CI/CD pipeline
- `.gitignore`: Git exclusions

## Prerequisites
- Git and a GitHub account
- Jenkins with Pipeline and Git plugins
- A Jenkins agent with Docker CLI/daemon access and `curl`
- A reachable Jenkins URL for GitHub webhooks (public HTTPS endpoint or approved lab network)

Important: do not expose Jenkins directly to the internet without proper authentication, HTTPS, and network controls. For a local-only lab, use Poll SCM or manual builds instead of a public webhook.

## Run locally with Docker
From this folder:
```bash
docker build -t triggerflow-web:latest .
docker run --rm -d --name triggerflow-web -p 8081:80 triggerflow-web:latest
```
Open http://localhost:8081. Stop the container with:
```bash
docker stop triggerflow-web
```

## Put the project on GitHub
Create an empty GitHub repository, then run from this folder:
```bash
git init
git add .
git commit -m "Initial TriggerFlow project"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```
Replace the URL with your own repository URL.

## Configure Jenkins
1. Install/enable Pipeline and Git plugins; install the GitHub plugin if using its webhook trigger.
2. Ensure the Jenkins agent executing this pipeline can run `docker ps`, `docker build`, `docker run`, and `curl`.
3. Create **New Item → Pipeline → Pipeline script from SCM**.
4. Select Git, enter your repository URL, choose branch `*/main`, and set script path to `Jenkinsfile`.
5. Save and click **Build Now** for the first run.

### Trigger A — manual
Use **Build Now** in Jenkins. This is the simplest first test.

### Trigger B — GitHub webhook
1. In the Jenkins job configuration, enable **GitHub hook trigger for GITScm polling**.
2. In GitHub repository **Settings → Webhooks → Add webhook**, set Payload URL to `https://YOUR-JENKINS-URL/github-webhook/`.
3. Choose `application/json` and select **Just the push event**.
4. Save, then push a code change. Confirm the webhook delivery and Jenkins build history.
5. A localhost-only Jenkins instance cannot receive GitHub webhooks directly. Use a properly secured, reachable HTTPS endpoint approved by your lab, or demonstrate Poll SCM instead.

### Trigger C — Poll SCM
In the `Jenkinsfile`, uncomment:
```groovy
triggers {
    pollSCM('H/5 * * * *')
}
```
Commit and push the change. Jenkins checks the SCM approximately every five minutes and builds when it detects changes. Avoid enabling multiple trigger mechanisms at once during a demonstration.

### Trigger D — scheduled build
Instead of Poll SCM, use:
```groovy
triggers {
    cron('H 9 * * 1-5')
}
```
This schedules a build on weekdays around 9 AM according to Jenkins' configured timezone. Use this instead of the Poll SCM trigger when demonstrating a timer-based trigger.

## Expected results
- Jenkins stages show Checkout, Validate Project Files, Build Docker Image, Deploy Container, and Smoke Test.
- Successful pipeline ends with `Finished: SUCCESS`.
- Open `http://localhost:8081` on the machine running Docker to view the TriggerFlow page.
- After a new code push, the build number should increase and the running container should be replaced with the newly built version.

## Troubleshooting
- **Docker permission denied:** grant the Jenkins agent account authorized Docker access according to your lab administrator's policy, then restart the agent if needed. Docker access is highly privileged.
- **Port 8081 in use:** change `HOST_PORT` in the Jenkinsfile and local run command.
- **Webhook not triggering:** check the GitHub webhook delivery status, Jenkins URL, plugin and job trigger checkbox, and that the Jenkins endpoint is reachable.
- **Pipeline cannot find Docker:** run the job on an agent with Docker installed and a working Docker daemon.
- **Smoke test fails:** inspect the container with `docker logs triggerflow-web` and verify the port mapping.
- **Jenkinsfile uses `sh`:** run on a Linux-based Jenkins agent or WSL/Linux environment. A native Windows agent requires adapting shell steps to PowerShell/batch.

## Lab report outline
1. Title
2. Aim
3. Problem statement
4. Software and hardware requirements
5. System architecture / workflow
6. Implementation
7. Trigger types demonstrated
8. Test cases and results
9. Advantages and limitations
10. Conclusion

## Sample test cases
| Test | Action | Expected result |
|---|---|---|
| T1 | Click Build Now | Pipeline starts manually |
| T2 | Push a code change with webhook configured | Push event triggers pipeline |
| T3 | Push a code change with Poll SCM enabled | Next SCM poll detects the change |
| T4 | Wait for scheduled time | Cron trigger starts a build |
| T5 | Temporarily rename a required file in a test branch | Validation stage fails and failure is shown |

## Conclusion
TriggerFlow demonstrates how event-based and time-based triggers automate CI/CD. Jenkins coordinates validation and deployment, GitHub provides version control and webhook events, and Docker runs the packaged web application.
