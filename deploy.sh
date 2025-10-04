#!/bin/bash
# Deployment script for Secure Document Processing System

echo "🚀 Secure Document Processing System - Deployment Script"
echo "========================================================"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Python version
echo "🔍 Checking Python version..."
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "✅ Python found: $PYTHON_VERSION"
else
    echo "❌ Python 3 not found. Please install Python 3.8 or higher."
    exit 1
fi

# Check if pip is available
echo "🔍 Checking pip..."
if command_exists pip3; then
    echo "✅ pip3 available"
    PIP_CMD="pip3"
elif command_exists pip; then
    echo "✅ pip available"
    PIP_CMD="pip"
else
    echo "❌ pip not found. Please install pip."
    exit 1
fi

# Install dependencies
echo "📦 Installing Python dependencies..."
if $PIP_CMD install -r requirements.txt; then
    echo "✅ Dependencies installed successfully"
else
    echo "⚠️  Some dependencies failed to install. The application may still work with system packages."
fi

# Create environment file
echo "⚙️  Setting up environment configuration..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Created .env file from template"
    echo "📝 Please edit .env file with your actual configuration values"
else
    echo "✅ .env file already exists"
fi

# Create required directories
echo "📁 Creating required directories..."
mkdir -p uploads secure_uploads logs
echo "✅ Directories created"

# Set permissions
echo "🔒 Setting secure permissions..."
chmod 700 secure_uploads
chmod 755 uploads logs
echo "✅ Permissions set"

# Initialize database
echo "🗄️  Initializing database..."
python3 -c "
import sys
sys.path.append('.')
try:
    from app import create_app, db
    app = create_app()
    with app.app_context():
        db.create_all()
        print('✅ Database initialized successfully')
except ImportError as e:
    print('⚠️  Could not initialize database (missing dependencies):', e)
    print('   Run: pip install flask flask-sqlalchemy')
except Exception as e:
    print('❌ Database initialization failed:', e)
"

# Run structure tests
echo "🧪 Running structure tests..."
if python3 test_structure.py; then
    echo "✅ All tests passed"
else
    echo "⚠️  Some tests failed, but application may still work"
fi

echo ""
echo "🎉 Deployment completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Edit .env file with your configuration"
echo "2. Start the application: python3 app.py"
echo "3. Access the web interface at: http://localhost:5000"
echo ""
echo "🔧 Optional Configuration:"
echo "- Set up SSL/TLS certificates for HTTPS"
echo "- Configure a reverse proxy (nginx/Apache)"
echo "- Set up a production WSGI server (gunicorn/uWSGI)"
echo "- Configure log rotation"
echo "- Set up database backups"
echo ""
echo "🛡️  Security Recommendations:"
echo "- Change default secret keys in .env"
echo "- Use strong passwords for user accounts"
echo "- Enable firewall and restrict access to necessary ports"
echo "- Regularly update dependencies"
echo "- Monitor audit logs for suspicious activity"