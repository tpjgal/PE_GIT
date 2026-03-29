# Git Command Scenarios by Programming Language

## Table of Contents
1. [C++](#c)
2. [C#](#c-1)
3. [VB.NET](#vbnet)
4. [ASP.NET](#aspnet)
5. [FORTRAN](#fortran)
6. [VBA](#vba)

---

## C++

### Overview
C++ projects typically have complex build systems, multiple compiler outputs, and external dependencies.

### .gitignore for C++
```gitignore
# Compiled objects and libraries
*.o
*.a
*.so
*.so.*
*.dylib
*.dll
*.exe
*.out

# Build directories (CMake, Make, Bazel)
build/
cmake-build-debug/
cmake-build-release/
out/
dist/

# IDE specific
.vscode/
.idea/
*.sln
*.vcxproj
*.vcxproj.filters
*.vcxproj.user
*.cbp
*.codeblocks
Makefile

# Dependency management
vcpkg_installed/
conan/
hunter_cache/

# Temporary files
*.swp
*.swo
*~
.DS_Store

# Package managers
*.lock
conaninfo.txt
```

### Project Structure
```
my-cpp-project/
├── src/              # Source files (.cpp)
├── include/          # Header files (.h)
├── tests/            # Test files
├── CMakeLists.txt    # Build configuration
├── .gitignore
├── README.md
└── .gitmodules       # External dependencies
```

### Scenario 1: Starting a C++ Project

```bash
# Create project directory
mkdir my-cpp-project
cd my-cpp-project

# Initialize Git
git init

# Create basic structure
mkdir src include tests

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(my-cpp-project)

set(CMAKE_CXX_STANDARD 17)

add_executable(myapp src/main.cpp)
target_include_directories(myapp PRIVATE include)
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
*.o
*.a
*.so
build/
cmake-build-*/
.vscode/
EOF

# Initial commit
git add .
git commit -m "feat: initialize C++ project structure"

# Create branch for development
git checkout -b develop
```

### Scenario 2: Adding External C++ Dependencies (vcpkg)

```bash
# Add vcpkg as submodule for dependency management
git submodule add https://github.com/Microsoft/vcpkg.git vendor/vcpkg

# Create vcpkg.json for dependencies
cat > vcpkg.json << 'EOF'
{
  "name": "my-cpp-project",
  "version": "1.0.0",
  "dependencies": [
    "boost",
    "fmt",
    "sqlite3"
  ]
}
EOF

# Commit dependency configuration
git add .gitmodules vcpkg.json
git commit -m "chore: add vcpkg dependency management"

# Create feature branch for new feature using external lib
git checkout -b feature/use-json-library

# Add nlohmann/json dependency
cat >> vcpkg.json << 'EOF'
,
    "nlohmann-json"
EOF

git add vcpkg.json
git commit -m "feat: add nlohmann-json dependency"

# Push and create PR
git push origin feature/use-json-library
```

### Scenario 3: Build Output Management

```bash
# Verify build artifacts are ignored
mkdir -p build
cd build
cmake ..
make
cd ..

# Check Git status - build artifacts should NOT appear
git status
# (build/ directory not shown because in .gitignore)

# Track only source code
git add src/ include/ CMakeLists.txt
git commit -m "feat: implement json parser module"

# Push to remote
git push origin develop
```

### Scenario 4: Compiler-Specific Branches

```bash
# Different branches for different compilers
git branch feature/gcc-optimization
git branch feature/msvc-compatibility
git branch feature/clang-warnings

# Work on GCC version
git checkout feature/gcc-optimization

# Add GCC-specific optimizations
git add src/optimization.cpp
git commit -m "feat: add GCC-specific SIMD optimizations"

# Create PR to compare with other compiler versions
git push origin feature/gcc-optimization

# Later, merge when all compiler tests pass
git checkout develop
git merge feature/gcc-optimization -m "Merge GCC optimizations (all tests passing)"
```

### Scenario 5: C++ with CMake and CI/CD

```bash
# Check status before pushing
git status

# Verify build works
mkdir build && cd build
cmake .. && make && make test
cd ..

# If tests pass, commit
git add .
git commit -m "feat: add unit tests for data structures"

# Create release branch
git checkout -b release/1.0.0 develop

# Update version in CMakeLists.txt
# Modify: set(PROJECT_VERSION 1.0.0)

git add CMakeLists.txt
git commit -m "chore: bump version to 1.0.0"

# Merge to main
git checkout main
git merge --no-ff release/1.0.0 -m "Release 1.0.0"

# Tag release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main v1.0.0

# Cleanup
git branch -d release/1.0.0
```

### Scenario 6: Handling Compiler-Generated Files

```bash
# After compilation, many files generated
ls build/
# CMakeFiles/  obj/  bin/  lib/  *.a  *.o

# These should NOT be staged
git status
# Only .cpp and .h files appear, not artifacts

# Make code change
# Edit src/algorithm.cpp

git add src/algorithm.cpp
git commit -m "fix: improve algorithm efficiency"

# Create feature branch for debug version
git checkout -b feature/debug-symbols

# Add debug flag in CMakeLists.txt changes
git add CMakeLists.txt
git commit -m "feat: add debug symbol generation"

git push origin feature/debug-symbols
```

### Scenario 7: Collaborative C++ Development

```bash
# Two developers on same project
# Developer A: working on Parser
git checkout -b feature/parser
# Make changes...
git add src/parser.cpp include/parser.h
git commit -m "feat: implement expression parser"
git push origin feature/parser

# Developer B: working on Lexer (same time)
git checkout -b feature/lexer
# Make changes...
git add src/lexer.cpp include/lexer.h
git commit -m "feat: implement lexical analyzer"
git push origin feature/lexer

# Both create PRs
# After reviews, both merge to develop
# No conflicts if working in separate files

# Sync local
git checkout develop
git pull --recurse-submodules

# Now both features integrated
```

---

## C#

### Overview
C# projects use NuGet for package management, and Visual Studio generates many artifacts.

### .gitignore for C#
```gitignore
# Build results
[Dd]ebug/
[Dd]ebugPublic/
[Rr]elease/
[Rr]eleases/
x64/
x86/
[Ww][Ii][Nn]32/
[Aa][Rr][Mm]/
[Aa][Rr][Mm]64/
bld/
[Bb]in/
[Oo]bj/
[Ll]og/
[Ll]ogs/

# Visual Studio cache/options
.vs/
.vscode/
.idea/

# Visual Studio project files
*.sln
*.csproj.user
*.dcproj.user
*.sln.iml

# NuGet
packages/
.nuget/
*.nupkg
*.snupkg

# Test Results
[Tt]est[Rr]esult*/
[Bb]uild[Ll]og.*

# ReSharper
_ReSharper*/
*.resharper
*.resharper.user

# User-specific files
*.suo
*.user

# Rider
.idea/
*.sln.iml
```

### Project Structure
```
MyProject/
├── MyProject.sln
├── MyProject/
│   ├── MyProject.csproj
│   ├── Program.cs
│   └── bin/     (ignored)
├── MyProject.Tests/
│   ├── MyProject.Tests.csproj
│   └── UnitTests.cs
└── .gitignore
```

### Scenario 1: Setting Up C# Project with Git

```bash
# Create solution
dotnet new sln -n MyApp
cd MyApp

# Create class library
dotnet new classlib -n MyApp.Core -o MyApp.Core
dotnet sln add MyApp.Core

# Create console app
dotnet new console -n MyApp.CLI -o MyApp.CLI
dotnet sln add MyApp.CLI

# Create test project
dotnet new nunit -n MyApp.Tests -o MyApp.Tests
dotnet sln add MyApp.Tests

# Create .gitignore
cat > .gitignore << 'EOF'
[Dd]ebug/
[Rr]elease/
bin/
obj/
.vs/
.vscode/
*.user
EOF

# Initialize Git
git init

# Initial commit
git add .
git commit -m "feat: initialize C# project structure"

# Create develop branch
git checkout -b develop
```

### Scenario 2: NuGet Dependency Management

```bash
# Add dependencies via NuGet
dotnet add MyApp.Core package Newtonsoft.Json
dotnet add MyApp.Core package Entity Framework

# Git automatically tracks .csproj changes
git status
# MyApp.Core/MyApp.Core.csproj modified

# packages.lock.json tracks exact versions
git add MyApp.Core/MyApp.Core.csproj
git add MyApp.Core/packages.lock.json

git commit -m "chore: add Newtonsoft.Json and Entity Framework"

# Create feature branch for new feature
git checkout -b feature/json-serialization

# Implement feature using added dependencies
git add MyApp.Core/JsonHandler.cs
git commit -m "feat: implement JSON serialization helper"

git push origin feature/json-serialization
```

### Scenario 3: Unit Testing in C#

```bash
# Create test project
dotnet new nunit -n MyApp.Tests -o MyApp.Tests
dotnet sln add MyApp.Tests

# Add reference to main project
dotnet add MyApp.Tests reference MyApp.Core

# Commit test infrastructure
git add MyApp.Tests/
git add MyApp.sln

git commit -m "test: add unit test project with NUnit"

# Create feature with tests
git checkout -b feature/user-validation

# Write tests first
cat > MyApp.Tests/UserValidationTests.cs << 'EOF'
[TestFixture]
public class UserValidationTests
{
    [Test]
    public void ValidEmail_ReturnsTrue()
    {
        var validator = new UserValidator();
        Assert.IsTrue(validator.IsValidEmail("test@example.com"));
    }
}
EOF

git add MyApp.Tests/UserValidationTests.cs
git commit -m "test: add user validation tests"

# Implement feature
cat > MyApp.Core/UserValidator.cs << 'EOF'
public class UserValidator
{
    public bool IsValidEmail(string email)
    {
        return email.Contains("@");
    }
}
EOF

git add MyApp.Core/UserValidator.cs
git commit -m "feat: implement user validation"

# Run tests
dotnet test

# Push for review
git push origin feature/user-validation
```

### Scenario 4: Managing Configuration Files

```bash
# Create appsettings files
cat > appsettings.json << 'EOF'
{
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "DatabaseConnection": "Server=localhost;Database=myapp"
}
EOF

# NEVER commit secrets - create template
cat > appsettings.local.json << 'EOF'
{
  "ApiKey": "your-api-key-here",
  "Password": "your-password-here"
}
EOF

# Add local file to .gitignore
echo "appsettings.local.json" >> .gitignore

# Commit only template
cat > appsettings.template.json << 'EOF'
{
  "ApiKey": "YOUR_API_KEY",
  "Password": "YOUR_PASSWORD"
}
EOF

git add appsettings.json appsettings.template.json .gitignore
git commit -m "chore: add configuration files (template added)"

# Document in README
cat >> README.md << 'EOF'
## Setup

1. Copy appsettings.template.json to appsettings.local.json
2. Fill in your secrets
3. Never commit appsettings.local.json
EOF

git add README.md
git commit -m "docs: add setup instructions"
```

### Scenario 5: CI/CD Pipeline Integration

```bash
# Create GitHub Actions workflow
mkdir -p .github/workflows

cat > .github/workflows/dotnet.yml << 'EOF'
name: .NET

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '6.0.x'
    - name: Restore dependencies
      run: dotnet restore
    - name: Build
      run: dotnet build --no-restore
    - name: Test
      run: dotnet test --no-build --verbosity normal
EOF

git add .github/workflows/dotnet.yml
git commit -m "ci: add .NET build and test workflow"

# Now every push automatically builds and tests
git push origin develop
```

### Scenario 6: Release Management in C#

```bash
# Update version before release
# Edit Directory.Build.props or .csproj

cat > Directory.Build.props << 'EOF'
<Project>
  <PropertyGroup>
    <Version>2.1.0</Version>
    <Authors>Your Team</Authors>
  </PropertyGroup>
</Project>
EOF

# Create release branch
git checkout -b release/v2.1.0

git add Directory.Build.props
git commit -m "chore: bump version to 2.1.0"

# Build release package
dotnet build -c Release
dotnet pack -c Release

# Verify everything
dotnet test

# Merge to main
git checkout main
git merge --no-ff release/v2.1.0

# Tag it
git tag -a v2.1.0 -m "Release 2.1.0"

# Push NuGet package
dotnet nuget push bin/Release/MyApp.2.1.0.nupkg --api-key $NUGET_KEY

# Push to GitHub
git push origin main v2.1.0

# Clean up
git branch -d release/v2.1.0
```

---

## VB.NET

### Overview
VB.NET is similar to C# but with different syntax. Same tools and workflows apply.

### .gitignore for VB.NET
```gitignore
# Same as C# - Visual Studio generates identical artifacts
[Dd]ebug/
[Rr]elease/
bin/
obj/
.vs/
.vscode/
*.user
packages/
.nuget/
```

### Project Structure
```
MyVBProject/
├── MyVBProject.sln
├── MyVBProject/
│   ├── MyVBProject.vbproj
│   └── Module1.vb
└── .gitignore
```

### Scenario 1: VB.NET Project Setup

```bash
# Create solution
dotnet new sln -n MyVBApp

# Create VB.NET console app
dotnet new console -lang VB -n MyVBApp -o MyVBApp
cd MyVBApp
dotnet sln ../MyVBApp.sln add MyVBApp.vbproj

# Create .gitignore
cat > .gitignore << 'EOF'
[Dd]ebug/
[Rr]elease/
bin/
obj/
.vs/
*.user
EOF

# Initialize Git
git init

# Create initial structure with VB.NET module
cat > Module1.vb << 'EOF'
Module Module1
    Sub Main()
        Console.WriteLine("Hello VB.NET!")
    End Sub
End Module
EOF

git add .
git commit -m "feat: initialize VB.NET console application"
```

### Scenario 2: Converting C# Project References to VB.NET

```bash
# Add VB.NET library
dotnet new classlib -lang VB -n MyVBLib -o MyVBLib
dotnet sln add MyVBLib/MyVBLib.vbproj

# Create VB.NET class
cat > MyVBLib/Helper.vb << 'EOF'
Public Class Helper
    Public Shared Function Greet(name As String) As String
        Return $"Hello, {name}!"
    End Function
End Class
EOF

# Add reference from console app
dotnet add MyVBApp reference MyVBLib/MyVBLib.vbproj

# Use the library
cat > MyVBApp/Module1.vb << 'EOF'
Module Module1
    Sub Main()
        Dim message = MyVBLib.Helper.Greet("World")
        Console.WriteLine(message)
    End Sub
End Module
EOF

# Commit both
git add MyVBLib/
git add MyVBApp/Module1.vb
git add MyVBApp/MyVBApp.vbproj
git add MyVBApp.sln

git commit -m "feat: add VB.NET library and use from console app"
```

### Scenario 3: Branch Strategy for VB.NET Team

```bash
# Organize team work by feature
git checkout -b feature/logging-system

# Create logging module
cat > MyVBLib/Logger.vb << 'EOF'
Public Class Logger
    Public Shared Sub LogError(message As String)
        Console.WriteLine($"[ERROR] {message}")
    End Sub
End Class
EOF

git add MyVBLib/Logger.vb
git commit -m "feat: add logging module"

# Push for review
git push origin feature/logging-system

# Another dev: data access layer
git checkout develop
git checkout -b feature/data-access

cat > MyVBLib/Repository.vb << 'EOF'
Public Class Repository
    Public Function GetUsers() As List(Of String)
        Return New List(Of String)
    End Function
End Class
EOF

git add MyVBLib/Repository.vb
git commit -m "feat: add repository pattern"

git push origin feature/data-access

# Both features merge independently after review
```

---

## ASP.NET

### Overview
ASP.NET projects are web applications with web-specific structure and configuration.

### .gitignore for ASP.NET
```gitignore
# Build results
[Dd]ebug/
[Rr]elease/
bin/
obj/

# Published web
Publish/
PublishProfiles/

# VS specific
.vs/
.vscode/
*.user
*.suo

# Web configuration files with secrets
web.Config
appsettings.Development.json
appsettings.Production.json

# NuGet
packages/
.nuget/

# Node/npm (if using npm for frontend)
node_modules/
npm-debug.log

# wwwroot content (can be large)
wwwroot/lib/

# User uploads (if applicable)
Uploads/
```

### Project Structure
```
MyWebApp/
├── MyWebApp.sln
├── MyWebApp/
│   ├── MyWebApp.csproj
│   ├── Program.cs
│   ├── appsettings.json
│   ├── wwwroot/
│   ├── Controllers/
│   ├── Models/
│   ├── Views/
│   └── bin/      (ignored)
├── MyWebApp.Tests/
└── .gitignore
```

### Scenario 1: Set Up ASP.NET Web Application

```bash
# Create ASP.NET Core web application
dotnet new web -n MyWebApp -o MyWebApp
cd MyWebApp

# Create Git repository
git init

# Create .gitignore
cat > .gitignore << 'EOF'
[Dd]ebug/
[Rr]elease/
bin/
obj/
.vs/
appsettings.Development.json
appsettings.Production.json
node_modules/
wwwroot/lib/
EOF

# Commit initial project
git add .gitignore
git add MyWebApp.csproj Program.cs appsettings.json
git commit -m "feat: initialize ASP.NET Core web application"

# Create develop branch
git checkout -b develop
```

### Scenario 2: Database and EF Core Setup

```bash
# Add Entity Framework Core
dotnet add MyWebApp package Microsoft.EntityFrameworkCore
dotnet add MyWebApp package Microsoft.EntityFrameworkCore.SqlServer
dotnet add MyWebApp package Microsoft.EntityFrameworkCore.Design

# Commit dependencies
git add MyWebApp.csproj
git commit -m "chore: add Entity Framework Core packages"

# Create models
mkdir Models

cat > Models/User.cs << 'EOF'
public class User
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
}
EOF

# Create DbContext
cat > Models/AppDbContext.cs << 'EOF'
using Microsoft.EntityFrameworkCore;

public class AppDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        options.UseSqlServer("Server=localhost;Database=myapp;");
    }
}
EOF

git add Models/
git commit -m "feat: add database models and context"

# Create migration
dotnet ef migrations add InitialCreate

# Commit migration
git add Migrations/
git commit -m "chore: add initial database migration"

# Apply migration
dotnet ef database update
```

### Scenario 3: API Development with Controllers

```bash
# Create API controller
mkdir Controllers

cat > Controllers/UsersController.cs << 'EOF'
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly AppDbContext _context;
    
    public UsersController(AppDbContext context)
    {
        _context = context;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }
    
    [HttpPost]
    public async Task<ActionResult<User>> CreateUser(User user)
    {
        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetUsers), new { id = user.Id }, user);
    }
}
EOF

# Create feature branch
git checkout -b feature/user-api

git add Controllers/UsersController.cs
git commit -m "feat: add user API endpoints (GET, POST)"

# Test before pushing
dotnet test

git push origin feature/user-api
```

### Scenario 4: Authentication Implementation

```bash
# Add authentication packages
dotnet add MyWebApp package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet add MyWebApp package System.IdentityModel.Tokens.Jwt

git add MyWebApp.csproj
git commit -m "chore: add JWT authentication packages"

# Create auth service branch
git checkout -b feature/jwt-authentication

# Create authentication service
mkdir Services

cat > Services/AuthService.cs << 'EOF'
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;

public class AuthService
{
    private readonly IConfiguration _config;
    
    public AuthService(IConfiguration config)
    {
        _config = config;
    }
    
    public string GenerateToken(User user)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["JwtSecret"]));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        
        var token = new JwtSecurityToken(
            claims: new[] { new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()) },
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: creds
        );
        
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
EOF

git add Services/AuthService.cs
git commit -m "feat: implement JWT token generation service"

# Configure authentication in Program.cs
git add Program.cs
git commit -m "feat: configure JWT authentication middleware"

git push origin feature/jwt-authentication
```

### Scenario 5: Frontend Integration (Razor or Blazor)

```bash
# For Razor Pages example
mkdir Pages

cat > Pages/Index.cshtml << 'EOF'
@page
@model IndexModel

<div class="container">
    <h1>Users</h1>
    <div id="users"></div>
</div>

<script>
    fetch('/api/users')
        .then(response => response.json())
        .then(data => {
            document.getElementById('users').innerHTML = 
                data.map(u => `<p>${u.name} - ${u.email}</p>`).join('');
        });
</script>
EOF

# Create feature branch for UI
git checkout -b feature/user-dashboard

git add Pages/
git commit -m "feat: add user dashboard UI with API integration"

# Create CSS for styling
mkdir wwwroot/css

cat > wwwroot/css/style.css << 'EOF'
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}
EOF

git add wwwroot/css/
git commit -m "style: add basic styling"

git push origin feature/user-dashboard
```

### Scenario 6: Docker Containerization

```bash
# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /source
COPY MyWebApp.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o /app

FROM runtime
WORKDIR /app
COPY --from=build /app .

ENTRYPOINT ["dotnet", "MyWebApp.dll"]
EOF

# Create docker-compose
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
    depends_on:
      - db
  
  db:
    image: mcr.microsoft.com/mssql/server:2019-latest
    environment:
      SA_PASSWORD: YourPassword123!
      ACCEPT_EULA: Y
EOF

git add Dockerfile docker-compose.yml
git commit -m "chore: add Docker containerization"

# Update .gitignore
echo ".dockerignore" >> .gitignore
git add .gitignore
git commit -m "chore: add docker ignore configuration"
```

### Scenario 7: Deployment and Release

```bash
# Create release branch
git checkout -b release/v1.0.0 develop

# Update version
cat > Directory.Build.props << 'EOF'
<Project>
  <PropertyGroup>
    <Version>1.0.0</Version>
  </PropertyGroup>
</Project>
EOF

git add Directory.Build.props
git commit -m "chore: bump version to 1.0.0"

# Build production
dotnet publish -c Release -o publish

# Merge to main
git checkout main
git merge --no-ff release/v1.0.0

# Tag release
git tag -a v1.0.0 -m "Release 1.0.0 - User management API"

git push origin main v1.0.0

# Clean up branch
git branch -d release/v1.0.0
```

---

## FORTRAN

### Overview
FORTRAN is legacy language with complex compilation. Usually uses Make or CMake.

### .gitignore for FORTRAN
```gitignore
# Compiled objects
*.o
*.obj
*.mod
*.smod

# Executables
*.exe
*.out
*.app
*.x

# Libraries
*.a
*.so
*.dylib
*.lib

# Build directories
build/
dist/
obj_*

# IDE
.vscode/
.idea/
*.f95d

# Temporary
*.swp
*~
.DS_Store

# Documentation
docs/html/
docs/latex/
```

### Project Structure
```
myfortran/
├── src/
│   ├── main.f90
│   └── modules.f90
├── include/
├── tests/
├── Makefile (or CMakeLists.txt)
├── .gitignore
└── README.md
```

### Scenario 1: Initialize FORTRAN Project

```bash
# Create project structure
mkdir myfortran
cd myfortran
mkdir src include tests

# Create main program
cat > src/main.f90 << 'EOF'
program hello
    implicit none
    print *, "Hello from FORTRAN!"
end program hello
EOF

# Create Makefile
cat > Makefile << 'EOF'
FC = gfortran
FCFLAGS = -Wall -Wextra -O2
FFLAGS = -I./include

SOURCES = src/main.f90
OBJECTS = $(SOURCES:.f90=.o)
TARGET = myapp

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(FC) $(FCFLAGS) -o $@ $^

%.o: %.f90
	$(FC) $(FCFLAGS) $(FFLAGS) -c $< -o $@

clean:
	rm -f src/*.o src/*.mod $(TARGET)

.PHONY: all clean
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
*.o
*.mod
*.exe
build/
myapp
EOF

# Initialize Git
git init

git add src/ Makefile .gitignore README.md
git commit -m "feat: initialize FORTRAN project with Makefile"
```

### Scenario 2: FORTRAN Modules and Code Organization

```bash
# Create feature branch for new module
git checkout -b feature/numerical-methods

# Create module file
cat > src/numerical_methods.f90 << 'EOF'
module numerical_methods
    implicit none
    private
    public :: newton_raphson, bisection
    
    contains
    
    real function newton_raphson(f, f_prime, x0, tol)
        implicit none
        interface
            real function f(x)
                real :: x
            end function f
            real function f_prime(x)
                real :: x
            end function f_prime
        end interface
        real :: x0, tol, x
        
        x = x0
        do while (abs(f(x)) > tol)
            x = x - f(x) / f_prime(x)
        end do
        newton_raphson = x
    end function newton_raphson
    
    end module numerical_methods
EOF

# Update Makefile to include new module
cat >> Makefile << 'EOF'

# Module dependencies
src/main.o: src/numerical_methods.o
EOF

# Update main to use module
cat > src/main.f90 << 'EOF'
program numerical_app
    use numerical_methods
    implicit none
    
    print *, "Numerical Methods Module Loaded"
end program numerical_app
EOF

git add src/numerical_methods.f90 src/main.f90 Makefile
git commit -m "feat: add numerical methods module with Newton-Raphson"

git push origin feature/numerical-methods
```

### Scenario 3: FORTRAN with External Libraries

```bash
# Add MKL (Math Kernel Library) as submodule
git submodule add https://github.com/reference-mkl/mkl.git vendor/mkl

# Update Makefile with library linking
cat > Makefile << 'EOF'
FC = gfortran
FCFLAGS = -Wall -O2
LIBS = -lmkl_core -lmkl_sequential -lmkl_intel

SOURCES = src/main.f90 src/numerical_methods.f90
OBJECTS = $(SOURCES:.f90=.o)
TARGET = myapp

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(FC) $(FCFLAGS) -o $@ $^ $(LIBS)

%.o: %.f90
	$(FC) $(FCFLAGS) -c $< -o $@

clean:
	rm -f src/*.o src/*.mod $(TARGET)

.PHONY: all clean
EOF

git add .gitmodules Makefile
git commit -m "chore: add MKL external library support"
```

### Scenario 4: FORTRAN Testing

```bash
# Create test folder
mkdir -p tests

# Create test program
cat > tests/test_numerical.f90 << 'EOF'
program test_numerical
    use numerical_methods
    implicit none
    
    real :: result
    
    ! Test Newton-Raphson
    result = newton_raphson(f, f_prime, 2.0, 1e-6)
    print *, "Newton-Raphson result: ", result
    
contains
    real function f(x)
        real :: x
        f = x**2 - 2.0
    end function f
    
    real function f_prime(x)
        real :: x
        f_prime = 2.0 * x
    end function f_prime
    
end program test_numerical
EOF

# Update Makefile for tests
cat >> Makefile << 'EOF'

test: tests/test_numerical.o src/numerical_methods.o
	$(FC) $(FCFLAGS) -o test_run $^
	./test_run
EOF

git add tests/test_numerical.f90 Makefile
git commit -m "test: add numerical methods unit tests"

# Run tests
make test

# Commit pass
git add .
git commit -m "test: passing numerical method tests"
```

### Scenario 5: FORTRAN Release with CMake

```bash
# Switch to CMake for better portability
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(myfortran Fortran)

enable_language(Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)

add_executable(myapp 
    src/main.f90
    src/numerical_methods.f90
)

enable_testing()
add_test(NAME numerical_tests COMMAND test_numerical)
add_executable(test_numerical tests/test_numerical.f90 src/numerical_methods.f90)
EOF

git add CMakeLists.txt
git commit -m "build: add CMake configuration for cross-platform builds"

# Create build branch for release
git checkout -b release/v1.0.0

# Update version in CMake
sed -i 's/project(myfortran/project(myfortran VERSION 1.0.0/' CMakeLists.txt

git add CMakeLists.txt
git commit -m "chore: version 1.0.0 release"

git checkout main
git merge release/v1.0.0
git tag -a v1.0.0 -m "FORTRAN v1.0.0"

git push origin main v1.0.0
```

---

## VBA

### Overview
VBA is typically developed within Office applications. Different approach from standalone projects.

### .gitignore for VBA
```gitignore
# Excel files with macros (track .bas exports, not .xlsm directly)
*.xlsm
*.xlsb
*.pptm
*.docm

# Temporary files
~$*
*.tmp
.DS_Store

# IDE/Editor
.vscode/
*.bak

# Build/Compilation
*.bas.txt
```

### Project Structure
```
MyVBAProject/
├── .git
├── .gitignore
├── README.md
├── source/
│   ├── Module1.bas
│   ├── Class1.cls
│   └── ThisWorkbook.cls
├── tests/
│   └── TestModule.bas
└── workbooks/
    └── (reference only, not tracked)
```

### Scenario 1: Export VBA Code to Git

```bash
# VBA modules need to be exported to text files
# Use Microsoft Script Editor or VB Editor

# Create project structure
mkdir -p source tests workbooks
git init

# Create .gitignore
cat > .gitignore << 'EOF'
*.xlsm
*.xlsb
~$*
.DS_Store
workbooks/*.xlsm
EOF

# Export VBA modules as .bas files
# Manual process: In VBA Editor, File -> Export...
# Save as source/Module1.bas

cat > source/Module1.bas << 'EOF'
Attribute VB_Name = "Module1"
Sub HelloWorld()
    MsgBox "Hello from VBA!", vbInformation
End Sub
EOF

# Export ThisWorkbook class
cat > source/ThisWorkbook.cls << 'EOF'
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Workbook_Open()
    MsgBox "Workbook opened!"
End Sub
EOF

git add .gitignore source/
git commit -m "feat: initialize VBA project with modules"
```

### Scenario 2: VBA Class Development

```bash
# Create feature branch for new class
git checkout -b feature/database-class

# Create database class
cat > source/DatabaseConnection.cls << 'EOF'
Attribute VB_Name = "DatabaseConnection"
Option Explicit

Private connection As Object

Public Sub Connect(connectionString As String)
    Set connection = CreateObject("ADODB.Connection")
    connection.Open connectionString
End Sub

Public Function Query(sql As String) As Object
    Dim recordset As Object
    Set recordset = connection.Execute(sql)
    Set Query = recordset
End Function

Public Sub Disconnect()
    If Not connection Is Nothing Then
        connection.Close
        Set connection = Nothing
    End If
End Sub
EOF

git add source/DatabaseConnection.cls
git commit -m "feat: add database connection class"

# Create test file
cat > tests/TestDatabase.bas << 'EOF'
Attribute VB_Name = "TestDatabase"
Sub TestDatabaseConnection()
    Dim db As DatabaseConnection
    Set db = New DatabaseConnection
    
    db.Connect "Driver={SQL Server};Server=localhost;Database=test;"
    ' Test code
    db.Disconnect
End Sub
EOF

git add tests/TestDatabase.bas
git commit -m "test: add database connection tests"

git push origin feature/database-class
```

### Scenario 3: VBA with External References

```bash
# Document external references needed
cat > README.md << 'EOF'
# VBA Project Setup

## External References Required
1. Microsoft ActiveX Data Objects Library (ADODB)
2. Microsoft Excel Object Library
3. Microsoft Office Object Library

## Import Instructions
1. Open VBA Editor (Alt+F11)
2. Tools → References
3. Check the above libraries

## Module Import
1. Open VBA Editor
2. File → Import File
3. Select .bas and .cls files from source/
EOF

git add README.md
git commit -m "docs: add setup instructions for external references"

# Track reference configuration
cat > source/References.txt << 'EOF'
Reference="{00020905-0000-0000-C000-000000000046}"#2.0#0#C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE
Reference="{F5078F18-C551-11CF-B4B4-00A0204D0560}"#1.0#0#C:\Program Files\Common Files\System\ado\msado28.tlb
EOF

git add source/References.txt
git commit -m "chore: document required references"
```

### Scenario 4: VBA Module Organization

```bash
# Organize modules by functionality
mkdir -p source/utils source/core source/ui

# Utility functions
cat > source/utils/StringUtils.bas << 'EOF'
Attribute VB_Name = "StringUtils"
Option Explicit

Public Function TrimQuotes(inputStr As String) As String
    TrimQuotes = Replace(Replace(inputStr, """", ""), "'", "")
End Function

Public Function PadString(str As String, length As Integer) As String
    PadString = str & String(length - Len(str), " ")
End Function
EOF

# Core business logic
cat > source/core/DataProcessor.bas << 'EOF'
Attribute VB_Name = "DataProcessor"
Option Explicit

Public Function ProcessData(rawData As String) As String
    ProcessData = TrimQuotes(rawData)
End Function
EOF

# UI handlers
cat > source/ui/FormHandlers.bas << 'EOF'
Attribute VB_Name = "FormHandlers"
Option Explicit

Sub OnButtonClick()
    MsgBox "Button clicked!", vbInformation
End Sub
EOF

git add source/utils/ source/core/ source/ui/
git commit -m "refactor: organize VBA modules by functionality"
```

### Scenario 5: VBA Version Control Workflow

```bash
# Document VBA workflow
cat > VBAWORKFLOW.md << 'EOF'
# VBA Development Workflow

## Making Changes
1. Edit VBA code in Excel/Word VBA Editor
2. Export changed modules: File → Export
3. Stage and commit changes:
   git add source/*.bas source/*.cls
   git commit -m "feat: description of changes"

## Collaboration
1. Only .bas and .cls files are tracked in Git
2. .xlsm files are NOT tracked
3. Each developer has their own .xlsm file
4. Import source files to refresh your copy

## Importing Updates
1. Pull latest: git pull
2. Open VBA Editor (Alt+F11)
3. File → Import changed .bas/.cls files
4. Test in your workbook

## Conflicts
If two developers modify same module:
1. Resolve in Git (pick one or merge manually)
2. Re-export .bas file
3. Import latest version
EOF

git add VBAWORKFLOW.md
git commit -m "docs: add VBA development workflow guide"

# Create feature for reporting
git checkout -b feature/monthly-report

cat > source/core/ReportGenerator.bas << 'EOF'
Attribute VB_Name = "ReportGenerator"
Option Explicit

Public Sub GenerateMonthlyReport(year As Integer, month As Integer)
    ' Implementation
    MsgBox "Report generated for " & month & "/" & year
End Sub
EOF

git add source/core/ReportGenerator.bas
git commit -m "feat: add monthly report generator"

# Create test
cat > tests/TestReporting.bas << 'EOF'
Attribute VB_Name = "TestReporting"
Sub TestMonthlyReport()
    GenerateMonthlyReport 2024, 3
End Sub
EOF

git add tests/TestReporting.bas
git commit -m "test: add report generation tests"

git push origin feature/monthly-report
```

### Scenario 6: VBA with Continuous Documentation

```bash
# Create change log
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.2.0] - 2024-03-29
### Added
- Monthly report generation feature
- Database connection class
- StringUtils utility functions

### Fixed
- Connection timeout handling
- Excel reference management

## [1.1.0] - 2024-02-15
### Added
- Initial database module
- Form handlers

## [1.0.0] - 2024-01-01
### Added
- Core VBA modules
- Basic workbook structure
EOF

git add CHANGELOG.md
git commit -m "docs: initialize changelog"

# Tag version
git tag -a v1.2.0 -m "VBA v1.2.0 - Reporting features"
git push origin v1.2.0
```

---

## Quick Reference by Language

### C++
- **Build** Check: Make before committing
- **Key Ignore**: `*.o`, `build/`, `.vscode/`
- **Deps**: Submodules for external libs
- **Tests**: CTest integration
- **CI**: CMake + compiler versions

### C#
- **Build**: `dotnet build` before commit
- **Ignore**: `bin/`, `obj/`, `.vs/`, `*.user`
- **Deps**: NuGet packages (packages.lock.json tracked)
- **Tests**: NUnit, xUnit
- **CI**: GitHub Actions with dotnet

### VB.NET
- **Same as C#** - identical tooling
- **Syntax**: `.vb` extension
- **Features**: All C# features available
- **Deps**: Same NuGet ecosystem

### ASP.NET
- **Extends C#**: Add web-specific structure
- **Ignore**: `wwwroot/lib/`, migration history
- **Deps**: NuGet + npm (frontend)
- **Tests**: Integration + unit tests
- **Deploy**: Docker, Azure, Docker Compose

### FORTRAN
- **Build**: Make or CMake
- **Ignore**: `*.o`, `*.mod`, `build/`
- **Deps**: Submodules for MKL, BLAS
- **Tests**: Custom test programs
- **CI**: gfortran, ifort compiler tests

### VBA
- **Unique**: Track .bas/.cls, not .xlsm
- **Export**: Manual from Office Editor
- **Ignore**: `.xlsm`, temporary files
- **Tests**: Manual test macros
- **Collaborate**: Each dev own workbook

---

## Universal Best Practices Across All Languages

1. **Always add .gitignore early** - Prevent build artifacts leaking
2. **Track dependencies explicitly** - Lock files, package configs
3. **Test before committing** - Language-specific test runners
4. **Clear commit messages** - Especially for language-specific changes
5. **Document setup** - README with build instructions
6. **CI/CD integration** - Automate builds per language
7. **Version management** - Use semantic versioning consistently
8. **Code review** - Especially for language-specific patterns
9. **Separate branches by feature** - Not by language version
10. **Keep secrets out** - .gitignore environment configs

---

## Summary Table

| Language | Build Tool | Package Manager | Artifacts | Test Framework |
|----------|-----------|------------------|-----------|-----------------|
| C++ | CMake/Make | vcpkg/conan | .o, .a, bin/ | CTest/gtest |
| C# | dotnet | NuGet | bin/, obj/ | NUnit/xUnit |
| VB.NET | dotnet | NuGet | bin/, obj/ | NUnit/xUnit |
| ASP.NET | dotnet | NuGet/npm | bin/, obj/, node_modules | NUnit/xUnit |
| FORTRAN | Make/CMake | Manual/conan | .o, .mod | Custom |
| VBA | Manual | Office libs | .bas/.cls | Manual |

---

Remember: Git workflows are universal, but language-specific artifacts and configurations require tailored `.gitignore` and build processes.
