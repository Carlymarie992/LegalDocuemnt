# Quick Start Guide - Secure Document Processing System

## Overview
This system provides secure document processing, analysis, and organization for court trial use with comprehensive forensic logging and evidence integrity features.

## Prerequisites
- Python 3.8 or higher
- pip (Python package manager)
- At least 1GB available disk space
- Modern web browser

## Installation

### Option 1: Automated Deployment
```bash
# Clone the repository (if not already done)
git clone <repository-url>
cd Carlymarie992

# Run the deployment script
./deploy.sh
```

### Option 2: Manual Installation
```bash
# Install Python dependencies
pip install -r requirements.txt

# Copy environment template
cp .env.example .env

# Edit configuration (see Configuration section)
nano .env

# Create required directories
mkdir -p uploads secure_uploads logs

# Set permissions
chmod 700 secure_uploads

# Initialize database
python -c "from app import create_app, db; app = create_app(); app.app_context().push(); db.create_all()"

# Run tests
python test_structure.py
```

## Configuration

Edit the `.env` file with your specific configuration:

```bash
# Required: Change these secret keys
SECRET_KEY=your-unique-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key-here

# Database (SQLite for development, PostgreSQL for production)
DATABASE_URL=sqlite:///secure_docs.db

# File upload limits (in bytes)
MAX_CONTENT_LENGTH=104857600  # 100MB

# Security settings
BCRYPT_LOG_ROUNDS=12
RATE_LIMIT_DEFAULT=100 per hour

# Optional: AI service integration
OPENAI_API_KEY=your-openai-api-key
```

## Running the Application

### Development Mode
```bash
python app.py
```
Access at: http://localhost:5000

### Production Mode
```bash
# Install production server
pip install gunicorn

# Run with gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

## First Time Setup

1. **Access the web interface** at http://localhost:5000
2. **Register an admin user** (first user gets admin privileges)
3. **Upload test documents** to verify functionality
4. **Test processing features** (summarization, redaction, timeline)
5. **Review audit logs** for security monitoring

## API Usage

### Authentication
```bash
# Register a new user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"SecurePass123!"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"SecurePass123!"}'
```

### Document Upload
```bash
# Upload a document (requires authentication token)
curl -X POST http://localhost:5000/api/documents/upload \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "file=@document.pdf" \
  -F "case_number=CASE-2024-001" \
  -F "description=Evidence document"
```

### Document Processing
```bash
# Generate summary
curl -X POST http://localhost:5000/api/processing/documents/1/summarize \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"summary_type":"brief"}'

# Apply redactions
curl -X POST http://localhost:5000/api/processing/documents/1/redact \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"redaction_type":"pii"}'
```

## File Support

### Supported Document Types
- **PDF**: Text extraction and processing
- **Word Documents**: .doc, .docx files
- **Text Files**: .txt, .rtf files
- **Spreadsheets**: .xls, .xlsx, .csv files

### Supported Media Types (Transcription)
- **Audio**: .mp3, .wav, .flac files
- **Video**: .mp4, .avi, .mov files

### File Size Limits
- Default: 100MB per file
- Configurable via MAX_CONTENT_LENGTH in .env

## Security Features

### Authentication & Authorization
- JWT-based authentication with configurable expiration
- Role-based access control (user, admin, forensic_analyst)
- Password strength validation
- Rate limiting on sensitive endpoints

### File Security
- SHA256 integrity verification for all uploads
- Secure file storage with sanitized names
- Upload validation and virus scanning integration points
- Encrypted storage options

### Audit & Forensics
- Comprehensive audit logging for all actions
- Chain of custody records for evidence integrity
- Forensic data export for court use
- IP address and user agent tracking

### Data Protection
- PII detection and redaction
- Sensitive content filtering
- Secure session management
- CORS protection

## Monitoring & Maintenance

### Log Files
- Application logs: `logs/app.log`
- Audit logs: `logs/audit.log`
- Error logs: Check console output or system logs

### Database Backup
```bash
# SQLite backup
cp secure_docs.db secure_docs_backup_$(date +%Y%m%d).db

# PostgreSQL backup (if using PostgreSQL)
pg_dump secure_docs > backup_$(date +%Y%m%d).sql
```

### Health Monitoring
- Health check endpoint: `/health`
- Monitor disk space in upload directories
- Check audit log growth
- Verify database connectivity

## Troubleshooting

### Common Issues

1. **Import errors on startup**
   ```bash
   pip install -r requirements.txt
   ```

2. **Database connection errors**
   ```bash
   # Recreate database
   rm secure_docs.db
   python -c "from app import create_app, db; app = create_app(); app.app_context().push(); db.create_all()"
   ```

3. **File upload failures**
   - Check disk space
   - Verify upload directory permissions
   - Check file size limits

4. **Authentication issues**
   - Verify JWT secret key in .env
   - Check token expiration settings
   - Clear browser localStorage

### Debug Mode
```bash
# Enable debug mode
export FLASK_DEBUG=True
python app.py
```

## Production Deployment

### Security Checklist
- [ ] Change all default secret keys
- [ ] Set up HTTPS with SSL certificates
- [ ] Configure firewall rules
- [ ] Set up log rotation
- [ ] Enable database backups
- [ ] Configure monitoring alerts
- [ ] Review file permissions
- [ ] Set up intrusion detection

### Performance Optimization
- Use a production WSGI server (gunicorn, uWSGI)
- Configure a reverse proxy (nginx, Apache)
- Set up database connection pooling
- Enable file compression
- Configure caching headers

### Scaling Considerations
- Database: Migrate to PostgreSQL for production
- File Storage: Consider cloud storage for large volumes
- Load Balancing: Multiple application instances
- Monitoring: Application performance monitoring (APM)

## Support & Development

### Project Structure
```
├── app.py              # Main application
├── models.py           # Database models
├── routes/             # API endpoints
├── utils/              # Utility functions
├── templates/          # Web interface
├── static/             # CSS, JS, images
├── test_structure.py   # Structure validation
└── deploy.sh          # Deployment script
```

### Development Setup
```bash
# Install development dependencies
pip install flask-testing pytest

# Run tests
python -m pytest

# Code formatting
pip install black
black *.py routes/ utils/
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Run tests and structure validation
4. Submit a pull request

For questions or issues, please refer to the project documentation or create an issue in the repository.