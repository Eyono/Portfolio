# Static Website Hosted on AWS S3

This project is a static website hosted on Amazon S3. It is designed to provide a fast and simple user experience with content hosted globally via AWS S3 and optimized for low-latency delivery using Amazon CloudFront.

## Key Features
- Static content delivered using AWS S3 for high availability and performance.
- Content distributed globally using Amazon CloudFront for reducing latency and faster loading times.
- Custom CSS for styling and basic interactivity.

## Technologies Used
- AWS S3 (Static Website Hosting)
- Amazon CloudFront (Content Delivery Network)
- HTML
- CSS

## S3 Live Demo
[Visit the live site](https://web-buck-proj.s3.amazonaws.com/S3-static-hosting/index.html)

## CloudFront Live Demo
[Visit the live site](https://d251w67tkq18qq.cloudfront.net/)

## Screenshots
![image](https://github.com/user-attachments/assets/c2907a80-946b-484f-941a-2e79f42f62f4)

## Deployment on AWS S3 with CloudFront
1. Create an S3 bucket and enable static website hosting.
2. Upload HTML and CSS files.
3. Set public read permissions for the bucket.
4. CloudFront Distribution
   - Create a CloudFront Distribution and link it to the S3 bucket as the origin
   - Use CloudFront to cache your website's content at edge locations across the globe, ensuring faster load times for users regardless of their geographic 
      location.
   - Configure settings like cache behavior and HTTPS support (optional).
5. Access via CloudFront: After the distribution is deployed, access the website via the CloudFront URL, which optimizes content delivery by reducing latency.

## Benefits of Using CloudFront
- Low Latency: CloudFront caches content at edge locations around the world, reducing the time it takes to load your website for global users.
- Improved Performance: By using CloudFront’s global network, your website’s content is delivered from the closest edge server to your users.
- Scalability: As traffic to your website grows, CloudFront automatically handles the increased load, ensuring consistent performance.

## How CloudFront Works
CloudFront acts as a content delivery network (CDN) that caches your website’s static content (such as HTML, CSS, JavaScript, and images) at edge locations worldwide. When a user accesses your website, CloudFront serves the cached content from the nearest edge location, which reduces latency and improves load times. This makes your website more responsive and scalable for a global audience.

## Summary
By combining AWS S3 for hosting with Amazon CloudFront for content delivery, this project demonstrates a highly performant and globally optimized static website that provides a great user experience.
